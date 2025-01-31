// Importa pacotes necessários para testes no Flutter e mocks com mocktail
import 'package:flutter_test/flutter_test.dart'; 
import 'package:mocktail/mocktail.dart'; 
import 'package:bloc_test/bloc_test.dart'; // Utilizado para testar cubits e blocos
import 'package:movie_app_flutter/feature/data/models/movie.dart'; // Importa o modelo 'Filme'
import 'package:movie_app_flutter/feature/data/repository/movie_repository_impl.dart'; // Importa o repositório de filmes
import 'package:movie_app_flutter/feature/presentation/cubits/movie_cubit.dart'; // Importa o Cubit que gerencia o estado dos filmes

// Cria um mock do FilmeRepositoryImpl, para simular o comportamento dessa classe durante os testes
class MockFilmeRepositoryImpl extends Mock implements FilmeRepositoryImpl {}

void main() {
  // Declaração de variáveis que serão usadas nos testes
  late MockFilmeRepositoryImpl mockFilmeRepositoryImpl; // Mock do repositório de filmes
  late FilmeCubit filmeCubit; // O cubit que gerencia os filmes

  // Configuração antes de cada teste
  setUp(() {
    // Inicializa o mock do repositório de filmes
    mockFilmeRepositoryImpl = MockFilmeRepositoryImpl();
    // Inicializa o cubit, passando o mock do repositório
    filmeCubit = FilmeCubit(mockFilmeRepositoryImpl);
  });

  // Configuração após cada teste
  tearDown(() {
    // Fecha o cubit para liberar recursos
    filmeCubit.close();
  });

  // Teste 1: Verifica se os filmes são carregados corretamente
  blocTest<FilmeCubit, FilmeState>(
    // Descrição do teste
    'Deve emitir [FilmeLoading, FilmeLoaded] quando os filmes são carregados com sucesso',
    build: () {
      // Configura o mock para retornar uma lista de filmes populares quando chamado
      when(() => mockFilmeRepositoryImpl.buscarFilmesPopulares()).thenAnswer(
        (_) async => [
          Movie( // Um exemplo de filme a ser retornado
            id: 1,
            title: 'Filme 1',
            overview: 'Descrição do Filme 1',
            posterPath: '/caminho/para/poster1.jpg',
            voteCount: 100,
            releaseDate: '2023-01-01',
            popularity: 7.5,
            genreIds: [28, 12], // IDs de gênero fictícios
          ),
        ],
      );
      return filmeCubit; // Retorna o cubit para ser usado no teste
    },
    act: (cubit) => cubit.carregarFilmesPopulares(), // Ação a ser executada: carregar filmes populares
    expect: () => [
      FilmeLoading(), // Espera-se que o cubit emita o estado de carregamento primeiro
      FilmeLoaded(movie: [ // Depois, espera-se que o cubit emita o estado de sucesso com a lista de filmes
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
      ]),
    ],
  );

  // Teste 2: Verifica o comportamento do cubit quando ocorre um erro ao carregar os filmes
  blocTest<FilmeCubit, FilmeState>(
    // Descrição do teste
    'Deve emitir [FilmeLoading, FilmeError] quando ocorre um erro ao carregar os filmes',
    build: () {
      // Configura o mock para simular um erro ao buscar filmes populares
      when(() => mockFilmeRepositoryImpl.buscarFilmesPopulares()).thenThrow(Exception('Erro ao carregar filmes'));
      return filmeCubit; // Retorna o cubit para ser usado no teste
    },
    act: (cubit) => cubit.carregarFilmesPopulares(), // Ação a ser executada: carregar filmes populares
    expect: () => [
      FilmeLoading(), // Espera-se que o cubit emita o estado de carregamento
      FilmeError(message: 'Exception: Erro ao carregar filmes'), // Espera-se que o cubit emita o estado de erro com a mensagem de erro
    ],
  );
}
