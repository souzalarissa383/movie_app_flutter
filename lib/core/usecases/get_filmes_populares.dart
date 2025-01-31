import 'package:movie_app_flutter/feature/data/models/movie.dart';
import 'package:movie_app_flutter/feature/data/repository/movie_repository_impl.dart';


class GetFilmesPopulares {
  final FilmeRepositoryImpl repository;

  GetFilmesPopulares(this.repository);

  Future<List<Movie>> call() async {
    return await repository.buscarFilmesPopulares();
  }
}
