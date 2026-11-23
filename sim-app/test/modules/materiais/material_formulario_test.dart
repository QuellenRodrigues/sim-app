import 'package:app/modules/materiais/materiais.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _barra = GrupoMaterialModel(codigo: 4, nome: 'BARRA');

Future<void> _montar(WidgetTester tester, MateriaisState state) async {
  tester.view.physicalSize = const Size(1000, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  late MateriaisViewModel viewModel;
  await tester.runAsync(() async {
    viewModel = MateriaisViewModel(MateriaisRepositoryImpl(MateriaisDatasourceMock()));
    await Future<void>.delayed(const Duration(milliseconds: 600));
  });
  addTearDown(viewModel.dispose);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppThemeBase.theme,
      home: Scaffold(
        body: MaterialFormulario(
          formKey: GlobalKey<FormState>(),
          viewModel: viewModel,
          state: state,
          onSalvar: () {},
          onCancelar: () {},
          onExcluir: () {},
          onEditarColunas: () {},
          onAdicionarLinha: () {},
          onEditarLinha: (_) {},
          onExcluirLinha: (_) {},
        ),
      ),
    ),
  );
}

void main() {
  setUp(MateriaisDatasourceMock.reiniciar);

  testWidgets('abre o material enquanto a tabela de bitolas ainda carrega', (tester) async {
    const material = MaterialModel(codigo: 2, grupo: _barra, descricao: 'REDONDA', colunaBitola: 1);

    await _montar(
      tester,
      const MateriaisState(
        modo: MateriaisModo.edicao,
        selecionado: material,
        grupos: [_barra],
        grupo: _barra,
        colunaBitola: 1,
        carregandoTabela: true,
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Coluna 2'), findsOneWidget);
  });

  testWidgets('mostra o nome da coluna quando a tabela carregou', (tester) async {
    const material = MaterialModel(codigo: 2, grupo: _barra, descricao: 'REDONDA', colunaBitola: 1);

    await _montar(
      tester,
      const MateriaisState(
        modo: MateriaisModo.edicao,
        selecionado: material,
        grupos: [_barra],
        grupo: _barra,
        colunaBitola: 1,
        tabela: TabelaBitolasModel(colunas: ['Diametro Pol', 'Diametro MM']),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Diametro MM'), findsOneWidget);
  });
}
