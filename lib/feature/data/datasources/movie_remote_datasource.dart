// Importa o pacote 'dio', que é uma biblioteca para fazer requisições HTTP
import 'package:dio/dio.dart';
// Importa o modelo de filme
import 'package:movie_app_flutter/feature/data/models/movie.dart';

// Define a chave da API e a URL base da API do TMDB
const String apiKey = 'fd7de7243ea08e4dd35cc4a5297127e3';
const String baseUrl = 'https://api.themoviedb.org/3';

// Define um contrato (interface) que a fonte de dados remota de filmes deve seguir
abstract class FilmeRemoteDataSource {
  // Método que vai buscar os filmes populares
  Future<List<Movie>> getFilmesPopulares();
}

// Implementação da fonte de dados remota de filmes
class FilmeRemoteDataSourceImpl implements FilmeRemoteDataSource {
  // Dio é uma instância responsável por fazer as requisições HTTP
  final Dio dio;

  // Construtor que recebe uma instância de Dio
  FilmeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Movie>> getFilmesPopulares() async {
    try {
      // Realiza uma requisição GET para buscar filmes populares da API
      final response = await dio.get(
        // A URL completa da requisição, combinando a baseUrl com o endpoint de filmes populares
        '$baseUrl/movie/popular',
        // Parâmetros da query da requisição, incluindo a chave da API e o idioma
        queryParameters: {
          'api_key': apiKey,  // Chave da API
          'language': 'pt-BR', // Define que queremos os filmes em português
        },
      );

      // Verifica se a requisição foi bem-sucedida (código 200)
      if (response.statusCode == 200) {
        // Se a resposta for bem-sucedida, extrai a lista de resultados
        final List<dynamic> results = response.data['results'];
        // Converte cada item da lista para o modelo 'Filme' e retorna a lista
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        // Se o código de status não for 200, lança uma exceção
        throw Exception('Falha ao carregar filmes: ${response.statusCode}');
      }
    } catch (e) {
      // Se ocorrer algum erro, lança uma exceção com a mensagem de erro
      throw Exception('Erro ao carregar filmes: $e');
    }
  }
}
