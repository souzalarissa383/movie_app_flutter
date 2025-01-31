// Importa os pacotes necessários para o funcionamento da aplicação.
import 'package:flutter/material.dart'; // Para a estrutura da interface com o Material Design.
import 'package:dio/dio.dart'; // Para realizar chamadas HTTP.
import 'package:movie_app_flutter/feature/data/datasources/movie_remote_datasource.dart'; // Para o acesso aos dados remotos (API).
import 'package:movie_app_flutter/feature/data/repository/movie_repository_impl.dart'; // Para o repositório que gerencia a lógica de obtenção dos filmes.
import 'package:movie_app_flutter/feature/presentation/cubits/movie_cubit.dart'; // Para o gerenciamento de estado com Cubit.
import 'package:movie_app_flutter/feature/presentation/screens/screen_movie_catalog.dart'; // Tela onde os filmes serão exibidos.
import 'package:flutter_bloc/flutter_bloc.dart'; // Para utilizar o BLoC (Cubit).

void main() {
  // Cria uma instância do Dio, que será usada para realizar requisições HTTP.
  final dio = Dio();
  
  // Cria uma instância do FilmeRemoteDataSourceImpl, que utiliza o Dio para acessar dados de filmes.
  final filmeRemoteDataSource = FilmeRemoteDataSourceImpl(dio: dio);
  
  // Cria uma instância do FilmeRepositoryImpl, que usa o FilmeRemoteDataSource para buscar dados.
  final filmeRepository = FilmeRepositoryImpl(remoteDataSource: filmeRemoteDataSource);
  
  // Cria uma instância do FilmeCubit, que é responsável por gerenciar o estado dos filmes na aplicação.
  final filmeCubit = FilmeCubit(filmeRepository);

  // Inicia a aplicação, passando um MaterialApp como widget raiz.
  runApp(
    MaterialApp(
      home: BlocProvider(
        // O BlocProvider é responsável por fornecer o filmeCubit para toda a árvore de widgets abaixo dele.
        create: (context) => filmeCubit,
        
        // O widget CatalogoFilmesScreen será a tela inicial onde os filmes serão exibidos.
        child: CatalogoFilmesScreen(),
      ),
    ),
  );
}
