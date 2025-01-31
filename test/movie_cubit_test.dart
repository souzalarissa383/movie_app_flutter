// Importa os pacotes necessários para os testes, mocks e bloc_test.
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:movie_app_flutter/feature/data/models/movie.dart'; // Modelo de Filme.
import 'package:movie_app_flutter/feature/presentation/cubits/movie_cubit.dart'; // Cubit que gerencia o estado dos filmes.
import 'package:movie_app_flutter/feature/data/repository/movie_repository_impl.dart'; // Repositório responsável por buscar os filmes.


// Criação de um mock para o repositório de filmes, substituindo o comportamento real por um comportamento simulado.
class MockFilmeRepositoryImpl extends Mock implements FilmeRepositoryImpl {}

void main() {
  // Declaração das variáveis para armazenar as instâncias do mock e do cubit a ser testado.
  late MockFilmeRepositoryImpl mockFilmeRepositoryImpl;
  late FilmeCubit filmeCubit;

  // O 'setUp' é chamado antes de cada teste e prepara o ambiente.
  setUp(() {
    // Inicializa o MockFilmeRepositoryImpl.
    mockFilmeRepositoryImpl = MockFilmeRepositoryImpl();
    // Inicializa o FilmeCubit, passando o mock do repositório.
    filmeCubit = FilmeCubit(mockFilmeRepositoryImpl);
  });

  // O 'tearDown' é chamado após cada teste para limpar recursos, como o fechamento do cubit.
  tearDown(() {
    filmeCubit.close();
  });

  // Teste 1: Verifica se o cubit emite os estados corretos quando os filmes são carregados com sucesso.
  blocTest<FilmeCubit, FilmeState>(
    'Deve emitir [FilmeLoading, FilmeLoaded] quando os filmes são carregados com sucesso',
    build: () {
      // Configura o comportamento do mock para retornar uma lista de filmes populares simulada.
      when(() => mockFilmeRepositoryImpl.buscarFilmesPopulares()).thenAnswer(
        (_) async => [
          Movie(
            id: 1,
            title: 'Filme 1',
            overview: 'Descrição do Filme 1',
            posterPath: '/caminho/para/poster1.jpg',
            voteCount: 100,
            releaseDate: '2023-01-01',
            popularity: 7.5,
            genreIds: [28, 12],
          ),
        ],
      );
      // Retorna a instância do filmeCubit que será usada no teste.
      return filmeCubit;
    },
    act: (cubit) => cubit.carregarFilmesPopulares(), // Ação a ser realizada, que no caso é carregar os filmes.
    expect: () => [
      FilmeLoading(), // Espera-se que o estado inicial seja FilmeLoading.
      FilmeLoaded(movie: [
        Movie(
          id: 1,
          title: 'Filme 1',
          overview: 'Descrição do Filme 1',
          posterPath: '/caminho/para/poster1.jpg',
          voteCount: 100,
          releaseDate: '2023-01-01',
          popularity: 7.5,
          genreIds: [28, 12],
        ),
      ]), // Espera-se que, após a carga dos filmes, o estado seja FilmeLoaded com a lista de filmes.
    ],
  );

  // Teste 2: Verifica se o cubit emite os estados corretos quando ocorre um erro ao carregar os filmes.
  blocTest<FilmeCubit, FilmeState>(
    'Deve emitir [FilmeLoading, FilmeError] quando ocorre um erro ao carregar os filmes',
    build: () {
      // Configura o mock para lançar uma exceção quando tentar carregar os filmes.
      when(() => mockFilmeRepositoryImpl.buscarFilmesPopulares()).thenThrow(Exception('Erro ao carregar filmes'));
      return filmeCubit;
    },
    act: (cubit) => cubit.carregarFilmesPopulares(), // Ação a ser realizada é a mesma, tentar carregar os filmes.
    expect: () => [
      FilmeLoading(), // Espera-se que o estado inicial seja FilmeLoading.
      FilmeError(message: 'Exception: Erro ao carregar filmes'), // Espera-se que, após o erro, o estado seja FilmeError com a mensagem do erro.
    ],
  );
}
