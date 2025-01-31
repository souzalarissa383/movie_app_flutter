// Importa o arquivo necessário para acessar a fonte de dados remota e o modelo de filme.
import 'package:movie_app_flutter/feature/data/datasources/movie_remote_datasource.dart';
import 'package:movie_app_flutter/feature/data/models/movie.dart';

// Define a interface (contrato) do repositório, que contém a assinatura do método que busca filmes populares.
abstract class FilmeRepository {
  // O método buscarFilmesPopulares retorna uma lista de filmes (do tipo Filme) de forma assíncrona.
  Future<List<Movie>> buscarFilmesPopulares();
}

// Implementação do repositório, que é responsável por buscar os filmes populares.
class FilmeRepositoryImpl implements FilmeRepository {
  // A classe depende de uma fonte de dados remota para buscar os filmes populares. 
  // A dependência é passada via construtor (injeção de dependência).
  final FilmeRemoteDataSourceImpl remoteDataSource;

  // Construtor que recebe a fonte de dados remota como parâmetro obrigatório.
  FilmeRepositoryImpl({required this.remoteDataSource});

  // Implementa o método definido na interface. Aqui é onde a lógica para buscar filmes populares ocorre.
  @override
  Future<List<Movie>> buscarFilmesPopulares() async {
    try {
      // Tenta buscar a lista de filmes populares utilizando a fonte de dados remota.
      final filmes = await remoteDataSource.getFilmesPopulares();
      
      // Retorna a lista de filmes populares obtida da fonte de dados remota.
      return filmes;
    } catch (e) {
      // Caso ocorra um erro na busca dos filmes, lança uma exceção com a mensagem de erro.
      throw Exception("Erro ao carregar filmes: $e");
    }
  }
}
