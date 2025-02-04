// Importa o modelo de filme
import 'package:movie_app_flutter/feature/data/models/movie.dart';
// Importa a implementação do repositório de filmes
import 'package:movie_app_flutter/feature/data/repository/movie_repository_impl.dart';

// Classe responsável por obter a lista de filmes populares
class GetFilmesPopulares {
  // Repositório de filmes que será utilizado para buscar os dados
  final FilmeRepositoryImpl repository;
  
  // Construtor que recebe o repositório como parâmetro
  GetFilmesPopulares(this.repository);
  
  // Método assíncrono que retorna a lista de filmes populares
  Future<List<Movie>> call() async {
    return await repository.buscarFilmesPopulares();
  }
}
