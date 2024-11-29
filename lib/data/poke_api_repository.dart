import 'package:poke_api/poke_api.dart';

/// Repository for accessing Pokémon data.
class PokeApiRepository {
  final _pokeApiService = PokeApiService();

  Future<Pokemon> getPokemonByName(String name) {
    return _pokeApiService.getPokemonByName(name);
  }

  Future<PokemonList> getPokemons(int start, {int? limit}) {
    return _pokeApiService.getPokemons(start, limit: limit);
  }
}
