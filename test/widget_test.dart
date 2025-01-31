// Importa os pacotes necessários para o teste.
import 'package:flutter/material.dart'; 
import 'package:flutter_test/flutter_test.dart';

void main() {
  // O teste é realizado utilizando a função 'testWidgets', que permite testar widgets.
  testWidgets('Testa se o widget Text é renderizado corretamente', (WidgetTester tester) async {

    // Aqui estamos construindo o widget que será testado.
    // Utiliza o MaterialApp, Scaffold, Center e Text para montar a árvore de widgets.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('0'),  // Texto '0' sendo exibido dentro de um widget Center.
          ),
        ),
      ),
    );

    // 'pump()' atualiza a árvore de widgets e renderiza os widgets na tela.
    await tester.pump();

    // Verifica se o widget Text com o texto '0' está sendo exibido corretamente.
    expect(find.text('0'), findsOneWidget); 

    // Verifica se há exatamente um widget Center na árvore de widgets.
    expect(find.byType(Center), findsOneWidget); 

    // Encontrando o widget Center e o widget Text com o texto '0'.
    final centerWidget = find.byType(Center);
    final textWidget = find.text('0');

    // Compara se o widget Center realmente contém o widget Text com o texto '0'.
    expect(
      tester.widget<Center>(centerWidget).child,
      equals(tester.widget<Text>(textWidget)), 
    );

    // Aqui encontramos o widget Text pelo texto '0' e pegamos sua instância.
    final textWidgetFinder = find.text('0');
    final textWidgetInstance = tester.widget<Text>(textWidgetFinder);

    // Verifica se o dado do widget Text é igual a '0'.
    expect(textWidgetInstance.data, '0'); 

    // Verifica se o estilo do widget Text é nulo (não há estilo aplicado).
    expect(textWidgetInstance.style, isNull); 
  });
}
