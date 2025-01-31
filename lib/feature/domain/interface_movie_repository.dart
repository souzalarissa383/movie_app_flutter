// Importa o modelo de Filme que será utilizado para criar a lista de filmes
import 'package:movie_app_flutter/feature/data/models/movie.dart';

// Define a interface do repositório de filmes
abstract class IFilmeRepository {
  // Método que deve ser implementado para buscar os filmes populares
  // Esse método retorna uma lista de objetos do tipo Filme
  Future<List<Movie>> buscarFilmesPopulares();
}
