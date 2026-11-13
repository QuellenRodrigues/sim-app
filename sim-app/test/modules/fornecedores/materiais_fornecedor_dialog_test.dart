import 'package:app/modules/fornecedores/fornecedores.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _materiais = [
  MaterialFornecidoModel(codigo: 1, tipo: 'BARRA', descricao: 'REDONDA'),
  MaterialFornecidoModel(codigo: 2, tipo: 'TUBO', descricao: 'SCH. 40'),
  MaterialFornecidoModel(codigo: 3, tipo: 'CHAPA', descricao: 'GROSSA'),
];

/// Abre o diálogo e devolve uma função que lê o resultado depois que ele fecha.
Future<List<int>? Function()> _abrir(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  List<int>? resultado;
  await tester.pumpWidget(
    MaterialApp(
      theme: AppThemeBase.theme,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            resultado = await MateriaisFornecedorDialog.mostrar(context, disponiveis: _materiais);
          },
          child: const Text('abrir'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('abrir'));
  await tester.pumpAndSettle();
  return () => resultado;
}

void main() {
  testWidgets('devolve os materiais marcados, mesmo depois de filtrar a lista', (tester) async {
    final resultado = await _abrir(tester);

    await tester.tap(find.text('BARRA REDONDA'));
    await tester.pumpAndSettle();
    expect(tester.widget<CheckboxListTile>(find.byType(CheckboxListTile).first).value, isTrue);

    await tester.enterText(find.byType(TextField), 'tubo');
    await tester.pumpAndSettle();
    expect(find.text('BARRA REDONDA'), findsNothing);
    await tester.tap(find.text('TUBO SCH. 40'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Adicionar (2)'));
    await tester.pumpAndSettle();

    expect(resultado(), unorderedEquals([1, 2]));
  });

  testWidgets('não adiciona sem marcar nada', (tester) async {
    final resultado = await _abrir(tester);

    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();

    expect(find.byType(MateriaisFornecedorDialog), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(resultado(), isNull);
  });
}
