// Importação dos pacotes necessários
import 'package:flutter/material.dart'; 
import 'package:cached_network_image/cached_network_image.dart'; // Para carregar imagens de rede com cache
import 'package:movie_app_flutter/feature/data/models/movie.dart'; // Importa o modelo de dados 'Filme'
import 'package:movie_app_flutter/feature/presentation/screens/details_movie_screen.dart'; // Importa a tela de detalhes do filme

// Definição do widget FilmeCard que será exibido na lista de filmes
class FilmeCard extends StatelessWidget {
  // A classe recebe um objeto 'filme' do tipo Filme, que contém os dados do filme
  final Movie movie;

  // Construtor que recebe o filme e o inicializa
  const FilmeCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    // O widget retorna um GestureDetector, que detecta o toque do usuário
    return GestureDetector(
      onTap: () {
        // Quando o card é tocado, ele navega para a tela de detalhes do filme
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesFilmeScreen(movie: movie), // Passa o filme para a tela de detalhes
          ),
        );
      },
      child: Card(
        color: Colors.black, // Cor de fundo do card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha o conteúdo à esquerda
          children: [
            // A imagem do filme é exibida em um espaço expandido
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.7, // Define a proporção da imagem (largura/altura)
                child: CachedNetworkImage(
                  // Carrega a imagem do filme usando a URL
                  imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}', // A URL é montada com o caminho do poster
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()), // Mostra um carregando enquanto a imagem não é carregada
                  errorWidget: (context, url, error) => const Icon(Icons.error), // Exibe um ícone de erro se houver problema ao carregar a imagem
                  fit: BoxFit.cover, // A imagem deve cobrir toda a área disponível, mantendo a proporção
                ),
              ),
            ),
            // Abaixo da imagem, exibe o título do filme
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do texto
              child: Text(
                movie.title, // Exibe o título do filme
                style: const TextStyle(
                  color: Colors.white, // Cor do texto (branco)
                  fontSize: 16, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Define o peso da fonte como negrito
                ),
                maxLines: 2, // Limita o título a no máximo 2 linhas
                overflow: TextOverflow.ellipsis, // Se o título for maior que 2 linhas, ele será cortado com elipses (...)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
