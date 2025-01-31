// Importa o pacote 'mockito' para gerar mocks de classes para testes.
import 'package:mockito/annotations.dart';

// Importa o pacote 'http' com alias 'http' para fazer requisições HTTP.
import 'package:http/http.dart' as http;

// Gera um mock para a classe http.Client, permitindo que você crie instâncias dessa classe para testar sem fazer chamadas reais HTTP.
@GenerateMocks([http.Client])

void main() {}
