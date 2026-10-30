import 'package:app/modules/tabelas_auxiliares/tabelas_auxiliares.dart';
import 'package:flutter_test/flutter_test.dart';

/// Espera a lista recarregar (o datasource de exemplo simula a latência da rede).
Future<void> _aguardarDatasource() => Future<void>.delayed(const Duration(milliseconds: 300));

TabelasAuxiliaresViewModel _viewModel() =>
    TabelasAuxiliaresViewModel(TabelasAuxiliaresRepositoryImpl(TabelasAuxiliaresDatasourceMock()));

void main() {
  setUp(TabelasAuxiliaresDatasourceMock.reiniciar);

  group('TabelasAuxiliaresViewModel', () {
    test('abre nos grupos de máquina, em ordem alfabética', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      expect(viewModel.state.tabela, TabelaAuxiliar.gruposMaquina);
      expect(viewModel.state.itens, hasLength(25));
      expect(viewModel.state.itens.first.descricao, 'ACABAMENTO');
      viewModel.dispose();
    });

    test('troca de tabela e limpa a busca', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();
      viewModel.buscar('torno');

      viewModel.selecionarTabela(TabelaAuxiliar.destinos);
      await _aguardarDatasource();

      expect(viewModel.state.busca, isEmpty);
      expect(viewModel.state.itens.map((i) => i.descricao), ['INDUSTRIALIZAÇÃO', 'USO PRÓPRIO']);
      viewModel.dispose();
    });

    test('busca sem diferenciar acentos', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.buscar('preparacao');

      expect(viewModel.state.itensFiltrados.map((i) => i.descricao), ['PREPARAÇÃO']);
      viewModel.dispose();
    });

    test('inclui com o próximo código e altera um item', () async {
      final viewModel = _viewModel();
      viewModel.selecionarTabela(TabelaAuxiliar.tiposServico);
      await _aguardarDatasource();

      expect(await viewModel.salvar(descricao: '  PINTURA  '), isTrue);
      final novo = viewModel.state.itens.firstWhere((i) => i.descricao == 'PINTURA');
      expect(novo.codigo, 4);

      expect(await viewModel.salvar(descricao: 'SERVIÇO GERAL', codigo: 1), isTrue);
      expect(viewModel.state.itens.map((i) => i.descricao), contains('SERVIÇO GERAL'));
      expect(viewModel.state.itens, hasLength(4));
      viewModel.dispose();
    });

    test('não aceita descrição repetida na mesma tabela', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      final salvou = await viewModel.salvar(descricao: 'torno');

      expect(salvou, isFalse);
      expect(viewModel.state.aviso?.sucesso, isFalse);
      expect(viewModel.state.aviso?.texto, contains('Grupos de máquina'));
      viewModel.dispose();
    });

    test('excluir tira o item da lista e libera a descrição', () async {
      final viewModel = _viewModel();
      viewModel.selecionarTabela(TabelaAuxiliar.destinos);
      await _aguardarDatasource();

      await viewModel.excluir(viewModel.state.itens.first);

      expect(viewModel.state.itens.map((i) => i.descricao), ['USO PRÓPRIO']);
      expect(await viewModel.salvar(descricao: 'INDUSTRIALIZAÇÃO'), isTrue);
      expect(viewModel.state.itens.firstWhere((i) => i.descricao == 'INDUSTRIALIZAÇÃO').codigo, 3);
      viewModel.dispose();
    });
  });
}
