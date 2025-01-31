// Importa os pacotes necessários para o teste e mock.
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:movie_app_flutter/feature/data/datasources/movie_remote_datasource.dart';

// Criação de uma classe MockDio para simular o comportamento da biblioteca Dio em nossos testes.
class MockDio extends Mock implements Dio {}

void main() {
  // Variáveis para armazenar as instâncias do mock do Dio e o DataSource a ser testado.
  late MockDio mockDio;
  late FilmeRemoteDataSourceImpl filmeRemoteDataSource;

  // O 'setUp' é chamado antes de cada teste, para configurar o ambiente de teste.
  setUp(() {
    // Inicializa a instância do MockDio.
    mockDio = MockDio();
    // Cria uma instância de FilmeRemoteDataSourceImpl, passando o mockDio como parâmetro.
    filmeRemoteDataSource = FilmeRemoteDataSourceImpl(dio: mockDio);
  });

  // Teste para verificar se o método de pegar filmes populares funciona corretamente.
  test('Deve retornar filmes populares', () async {
    
    // Configura o comportamento do mockDio para quando a função 'get' for chamada.
    // Ela deve retornar uma resposta com filmes populares.
    when(() => mockDio.get(
          'https://api.themoviedb.org/3/movie/popular',  // URL da API de filmes populares.
          queryParameters: {
            'api_key': 'fd7de7243ea08e4dd35cc4a5297127e3',  // Chave de API para autenticação.
            'language': 'pt-BR',  // Idioma da resposta.
          },
        )).thenAnswer((_) async => Response(
              // Dados simulados da resposta que a API devolveria.
              data: {
                'results': [
                  {
                    'id': 1,
                    'title': 'Filme 1',  // Título do filme.
                    'overview': 'Descrição do Filme 1',  // Descrição do filme.
                    'poster_path': '/caminho/para/poster1.jpg',  // Caminho do poster do filme.
                    'vote_count': 100,  // Contagem de votos do filme.
                    'release_date': '2023-01-01',  // Data de lançamento do filme.
                    'popularity': 7.5,  // Popularidade do filme.
                    'genre_ids': [28, 12],  // Identificadores dos gêneros do filme.
                  },
                ],
              },
              statusCode: 200,  // Status da resposta (sucesso).
              requestOptions: RequestOptions(path: '/movie/popular'),  // Informações sobre a requisição.
            ));

    // Chama o método 'getFilmesPopulares' do 'filmeRemoteDataSource' e armazena o resultado.
    final filmes = await filmeRemoteDataSource.getFilmesPopulares();

    // Verifica se o número de filmes retornado é igual a 1 (filme popular simulados).
    expect(filmes.length, 1);

    // Verifica se o título do primeiro filme é 'Filme 1'.
    expect(filmes[0].title, 'Filme 1');
  });
}
