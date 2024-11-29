import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_app/data/poke_api_repository.dart';
import 'package:poke_app/ui/home/bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bloc = HomeBloc(PokeApiRepository());
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch data when scrolled to bottom
    _scrollController.addListener(() {
      if ((_scrollController.position.maxScrollExtent == _scrollController.offset) && !_bloc.state.hasReachedMax) {
        _bloc.add(OnPokemonsFetched());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc..add(OnPokemonsFetched()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Poke App with MVVM (Bloc)')),
        backgroundColor: Colors.white.withOpacity(.9),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(onChanged: (value) => _bloc.add(OnSearchPokemonChanged(name: value))),
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (_, state) {
                    if (state.status == HomeStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.status == HomeStatus.failure) {
                      return const Center(child: Text('Failed to load pokemons'));
                    } else if (state.status == HomeStatus.success && state.pokemons.isEmpty) {
                      return const Center(child: Text('No pokemons available'));
                    } else {
                      final pokemons = state.pokemons;
                      return ListView.separated(
                        padding: const EdgeInsets.only(top: 16),
                        controller: _scrollController,
                        itemCount: pokemons.length + (state.showBottomLoading ? 1 : 0),
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (_, index) {
                          if (index < pokemons.length) {
                            final pokemon = pokemons[index];
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                title: Text('${index + 1} ${pokemon.name}'),
                              ),
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
