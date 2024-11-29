part of 'home_bloc.dart';

final class HomeState extends Equatable {
  final HomeStatus status;
  final List<PokemonDTO> pokemons;
  final bool hasReachedMax;
  final bool showBottomLoading;

  const HomeState({
    this.status = HomeStatus.initial,
    this.pokemons = const [],
    this.hasReachedMax = false,
    this.showBottomLoading = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<PokemonDTO>? pokemons,
    bool? hasReachedMax,
    bool? showBottomLoading,
  }) {
    return HomeState(
      status: status ?? this.status,
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      showBottomLoading: showBottomLoading ?? this.showBottomLoading,
    );
  }

  @override
  List<Object> get props => [
        status,
        pokemons,
        hasReachedMax,
        showBottomLoading,
      ];
}

enum HomeStatus { initial, loading, success, failure }
