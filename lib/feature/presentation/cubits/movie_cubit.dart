// Importa as bibliotecas necessárias para o uso do BLoC e outras funcionalidades
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app_flutter/feature/data/models/movie.dart';  // Model de Filme
import 'package:movie_app_flutter/feature/data/repository/movie_repository_impl.dart';  // Repositório de Filmes
import 'package:equatable/equatable.dart';  // Para comparar objetos no BLoC

// Classe base para os estados de Filme, estende Equatable para comparação de objetos
abstract class FilmeState extends Equatable {
  @override
  List<Object?> get props => []; // Método obrigatório do Equatable, utilizado para comparação de instâncias
}

// Estado inicial, que indica que ainda não houve nenhuma ação
class FilmeInitial extends FilmeState {}

// Estado de carregamento, indicando que os filmes estão sendo buscados
class FilmeLoading extends FilmeState {}

// Estado quando os filmes são carregados com sucesso, guarda a lista de filmes
class FilmeLoaded extends FilmeState {
  final List<Movie> movie; // A lista de filmes que foi carregada

  // Construtor que recebe os filmes
  FilmeLoaded({required this.movie});

  // Sobrescreve o método props para permitir comparação da lista de filmes
  @override
  List<Object?> get props => [movie]; 
}

// Estado de erro, que guarda a mensagem de erro caso ocorra algum problema
class FilmeError extends FilmeState {
  final String message; // A mensagem de erro

  // Construtor que recebe a mensagem de erro
  FilmeError({required this.message});

  // Sobrescreve o método props para permitir comparação da mensagem de erro
  @override
  List<Object?> get props => [message];
}

// O Cubit gerencia os estados e realiza as ações relacionadas aos filmes
class FilmeCubit extends Cubit<FilmeState> {
  final FilmeRepositoryImpl filmeRepository;  // Repositório de filmes

  // Construtor que recebe o repositório de filmes e inicializa o estado com FilmeInitial
  FilmeCubit(this.filmeRepository) : super(FilmeInitial());

  // Função assíncrona para carregar os filmes populares
  Future<void> carregarFilmesPopulares() async {
    emit(FilmeLoading());  // Emite o estado de carregamento

    try {
      // Tenta buscar os filmes populares no repositório
      final movie = await filmeRepository.buscarFilmesPopulares();
      emit(FilmeLoaded(movie: movie));  // Emite o estado com os filmes carregados
    } catch (e) {
      // Caso ocorra um erro, emite o estado de erro com a mensagem de erro
      emit(FilmeError(message: e.toString()));
    }
  }
}
