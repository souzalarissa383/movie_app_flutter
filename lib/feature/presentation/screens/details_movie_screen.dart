import 'package:flutter/material.dart';
import 'package:movie_app_flutter/feature/data/models/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetalhesFilmeScreen extends StatefulWidget {
  final Movie movie;

  const DetalhesFilmeScreen({required this.movie, super.key});

  @override
  _DetalhesFilmeScreenState createState() => _DetalhesFilmeScreenState();
}

class _DetalhesFilmeScreenState extends State<DetalhesFilmeScreen> {
  late Future<Map<String, dynamic>> filmeDetalhes;
  late Future<List<dynamic>> filmesSimilares;
  late Future<Map<int, String>> generos;
  bool isLiked = false;
  Set<int> watchedMovies = {}; // Para rastrear filmes assistidos

  @override
  void initState() {
    super.initState();
    filmeDetalhes = fetchFilmeDetalhes(widget.movie.id);
    filmesSimilares = fetchFilmesSimilares(widget.movie.id);
    generos = fetchGeneros();
  }

  Future<Map<String, dynamic>> fetchFilmeDetalhes(int movie_id) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movie_id?api_key=fd7de7243ea08e4dd35cc4a5297127e3');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao carregar detalhes do filme');
    }
  }

  Future<List<dynamic>> fetchFilmesSimilares(int movie_id) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movie_id/similar?api_key=fd7de7243ea08e4dd35cc4a5297127e3');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] as List<dynamic>;
    } else {
      throw Exception('Erro ao carregar filmes similares');
    }
  }

  Future<Map<int, String>> fetchGeneros() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=fd7de7243ea08e4dd35cc4a5297127e3');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      Map<int, String> generosMap = {};
      for (var genre in data['genres']) {
        generosMap[genre['id']] = genre['name'];
      }
      return generosMap;
    } else {
      throw Exception('Erro ao carregar gêneros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: filmeDetalhes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              } else if (snapshot.hasData) {
                final filmeData = snapshot.data!;

                return FutureBuilder<List<dynamic>>(
                  future: filmesSimilares,
                  builder: (context, similarSnapshot) {
                    if (similarSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (similarSnapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro: ${similarSnapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (similarSnapshot.hasData) {
                      final filmesSimilaresData = similarSnapshot.data!;
                      

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                _buildBackgroundImage(),
                                _buildGradientOverlay(),
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '❤ ${filmeData['vote_count']} Likes',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      Text(
                                       ' ${filmeData['popularity'].toStringAsFixed(2)} Views',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 50,
                                  left: 16,
                                  right: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.movie.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      _buildLikeButton(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _buildFilmesSimilares(filmesSimilaresData),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Nenhum filme similar encontrado',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'Nenhum dado encontrado',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            },
          ),
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.movie.getPosterUrl()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.black.withOpacity(0.5),
            Colors.transparent,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildLikeButton() {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.white,
        size: 30,
      ),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
      },
    );
  }

  Widget _buildFilmesSimilares(List<dynamic> filmes) {
    return FutureBuilder<Map<int, String>>(
      future: generos,
      builder: (context, genreSnapshot) {
        if (genreSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (genreSnapshot.hasError) {
          return Center(
            child: Text(
              'Erro: ${genreSnapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        } else if (genreSnapshot.hasData) {
          final generos = genreSnapshot.data!;
          return Container(
            color: Colors.black, // Fundo preto
            padding: const EdgeInsets.only(top: 16), // Espaçamento superior
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filmes.length,
              itemBuilder: (context, index) {
                final filme = filmes[index];
                final genreNames = filme['genre_ids']
                    .map<int>((id) => id as int)
                    .map((id) => generos[id] ?? 'Desconhecido')
                    .join(', ');
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/w200${filme['poster_path']}',
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filme['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${filme['release_date'].toString().split('-')[0]} • $genreNames',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          watchedMovies.contains(filme['id'])
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: Colors.white, // Cor do ícone
                        ),
                        onPressed: () {
                          setState(() {
                            if (watchedMovies.contains(filme['id'])) {
                              watchedMovies.remove(filme['id']);
                            } else {
                              watchedMovies.add(filme['id']);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text(
              'Nenhum gênero encontrado',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }
}