// Importando o pacote 'equatable' para ajudar a comparar objetos de forma simples
import 'package:equatable/equatable.dart';

// Classe Filme que estende a classe Equatable para permitir comparações fáceis
class Movie extends Equatable {
  // Definindo as variáveis que representam os dados de um filme
  final int id;            // ID único do filme
  final String title;      // Título do filme
  final String overview;   // Resumo/descrição do filme
  final String posterPath; // Caminho da imagem do poster
  final int voteCount;     // Número de votos que o filme recebeu
  final String releaseDate; // Data de lançamento do filme
  final double popularity; // Popularidade do filme
  final List<int> genreIds; // Lista de IDs de gêneros do filme
  final int viewCount;           // Contagem de visualizações do filme (valor inicial 0)

  // Construtor da classe Filme que inicializa todas as variáveis
  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteCount,
    required this.releaseDate,
    required this.popularity,
    required this.genreIds,
    this.viewCount = 0,  // Valor default 0 para viewCount
  });

  // Método de fábrica que cria um objeto Filme a partir de um mapa JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,                         // Atribuindo o valor do ID
      title: json['title'] as String,                 // Atribuindo o título
      overview: json['overview'] as String,           // Atribuindo o resumo
      posterPath: json['poster_path'] as String,     // Atribuindo o caminho do poster
      voteCount: json['vote_count'] as int,           // Atribuindo a contagem de votos
      releaseDate: json['release_date'] as String,   // Atribuindo a data de lançamento
      popularity: (json['popularity'] as num).toDouble(), // Convertendo popularidade para double
      genreIds: List<int>.from(json['genre_ids']),   // Convertendo a lista de IDs de gênero
      viewCount: json['view_count'] ?? 0,             // Usando 0 como padrão caso não tenha 'view_count'
    );
  }

  // Método para gerar a URL do poster do filme
  String getPosterUrl() {
    return 'https://image.tmdb.org/t/p/w500$posterPath'; // Retorna o caminho completo da imagem
  }

  // Sobrescreve o método 'props' para permitir a comparação de objetos Filme com base nos seus atributos
  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        voteCount,
        releaseDate,
        popularity,
        genreIds,
        viewCount,
      ];
}
