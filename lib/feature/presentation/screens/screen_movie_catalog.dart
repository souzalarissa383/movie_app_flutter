import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_flutter/feature/presentation/cubits/movie_cubit.dart';
import 'package:movie_app_flutter/feature/presentation/widgets/movie_card.dart';

class CatalogoFilmesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Carrega os filmes populares ao iniciar a tela
    context.read<FilmeCubit>().carregarFilmesPopulares();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Catálogo de Filmes",
          style: TextStyle(color: Colors.white), // Cor da fonte alterada para branco
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(26, 26, 29, 1),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<FilmeCubit, FilmeState>(
          builder: (context, state) {
            if (state is FilmeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FilmeLoaded) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _calculateCrossAxisCount(context),
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.6, // Ajuste este valor conforme necessário
                ),
                itemCount: state.movie.length,
                itemBuilder: (context, index) {
                  final movie = state.movie[index];
                  return FilmeCard(movie: movie);
                },
              );
            } else if (state is FilmeError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Função para calcular o número de colunas com base na largura da tela
  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return 3; // Para tablets e telas maiores
    } else {
      return 2; // Para smartphones
    }
  }
}