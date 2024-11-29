import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:poke_app/data/poke_api_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:poke_app/ui/home/bloc/pokemon_dto.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PokeApiRepository _pokeApiRepository;

  HomeBloc(this._pokeApiRepository) : super(const HomeState()) {
    on<OnPokemonsFetched>(_onPokemonsFetched);
    on<OnSearchPokemonChanged>(_onSearchPokemonChanged, transformer: _debounceTransformer);
  }

  Stream<OnSearchPokemonChanged> _debounceTransformer(Stream<OnSearchPokemonChanged> events,
      Stream<OnSearchPokemonChanged> Function(OnSearchPokemonChanged) transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 500)).switchMap(transitionFn);
  }

  Future<void> _onPokemonsFetched(OnPokemonsFetched event, Emitter<HomeState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == HomeStatus.initial) {
        // Initial fetch first page
        emit(state.copyWith(status: HomeStatus.loading));
        final list = await _pokeApiRepository.getPokemons(0);
        emit(state.copyWith(
          status: HomeStatus.success,
          pokemons: list.results.map((p) => PokemonDTO(name: p.name)).toList(),
          hasReachedMax: false,
        ));
      } else {
        emit(state.copyWith(showBottomLoading: true));
        final list = await _pokeApiRepository.getPokemons(state.pokemons.length);
        emit(list.results.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: HomeStatus.success,
                pokemons: List.of(state.pokemons)..addAll(list.results.map((p) => PokemonDTO(name: p.name)).toList()),
                hasReachedMax: false,
                showBottomLoading: false,
              ));
      }
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, showBottomLoading: false));
    }
  }

  Future<void> _onSearchPokemonChanged(OnSearchPokemonChanged event, Emitter<HomeState> emit) async {
    try {
      if (event.name.trim().isEmpty) {
        // No search -> clear results and fetch the first page
        emit(state.copyWith(status: HomeStatus.initial, pokemons: []));
        add(OnPokemonsFetched());
      } else {
        emit(state.copyWith(status: HomeStatus.loading));
        final pokemon = await _pokeApiRepository.getPokemonByName(event.name.trim().toLowerCase());
        emit(state.copyWith(status: HomeStatus.success, pokemons: [PokemonDTO(name: pokemon.name)]));
      }
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
