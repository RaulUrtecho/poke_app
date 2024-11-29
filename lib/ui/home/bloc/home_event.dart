part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class OnPokemonsFetched extends HomeEvent {}

final class OnSearchPokemonChanged extends HomeEvent {
  final String name;

  const OnSearchPokemonChanged({required this.name});
}
