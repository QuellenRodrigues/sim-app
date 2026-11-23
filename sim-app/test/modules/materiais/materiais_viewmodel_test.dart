import 'package:app/modules/materiais/materiais.dart';
import 'package:app/modules/tabelas_auxiliares/tabelas_auxiliares.dart';
import 'package:flutter_test/flutter_test.dart';

/// Espera a lista recarregar (o datasource de exemplo simula a latência da rede).
Future<void> _aguardar() => Future<void>.delayed(const Duration(milliseconds: 500));

MateriaisViewModel _viewModel() => MateriaisViewModel(MateriaisRepositoryImpl(MateriaisDatasourceMock()));

MaterialModel _porNome(MateriaisViewModel viewModel, String nome) =>
    viewModel.state.materiais.firstWhere((m) => m.nome == nome);

/// Abre o material e espera a tabela de bitolas carregar.
Future<MateriaisViewModel> _aberto(String nome) async {
  final viewModel = _viewModel();
  await _aguardar();
  viewModel.selecionar(_porNome(viewModel, nome));
  await _aguardar();
  return viewModel;
}

void main() {
  setUp(() {
    MateriaisDatasourceMock.reiniciar();
    TabelasAuxiliaresDatasourceMock.reiniciar();
  });

  group('Catálogo do SIM de 2017', () {
    test('traz os 54 materiais, agrupados e com as bitolas', () async {
      final viewModel = _viewModel();
      await _aguardar();

      expect(viewModel.state.materiais, hasLength(54));
      expect(viewModel.state.grupos, hasLength(18));
      expect(viewModel.state.materiais.first.grupo.nome, 'BARRA');
      expect(_porNome(viewModel, 'BARRA REDONDA').quantidadeBitolas, 145);
      expect(viewModel.state.materiais.fold<int>(0, (soma, m) => soma + m.quantidadeBitolas), 1536);
      viewModel.dispose();
    });

    test('barra redonda abre com a tabela e as opções do orçamento', () async {
      final viewModel = await _aberto('BARRA REDONDA');

      final tabela = viewModel.state.tabela;
      expect(tabela.colunas, ['Diametro Pol', 'Diametro MM', 'kg / metro', 'area']);
      expect(tabela.linhas.first.valores, ['1/8"', '3,18', '0,062', '0,0100']);
      expect(viewModel.state.colunaBitola, 0);
      expect(viewModel.state.medidas, {
        MedidaOrcamento.diametro,
        MedidaOrcamento.comprimento,
        MedidaOrcamento.peso,
      });
      viewModel.dispose();
    });

    test('busca pelo começo das palavras: "sch 40" não traz SCH. 140', () async {
      final viewModel = _viewModel();
      await _aguardar();

      viewModel.buscar('tubo sch 40', espera: Duration.zero);
      await _aguardar();
      expect(viewModel.state.materiais.map((m) => m.nome), ['TUBO SCH. 40']);

      viewModel.buscar('redonda', espera: Duration.zero);
      await _aguardar();
      expect(viewModel.state.materiais.map((m) => m.nome), ['BARRA REDONDA']);
      viewModel.dispose();
    });
  });

  group('MateriaisViewModel', () {
    test('cadastra um material e abre direto na edição, sem tabela', () async {
      final viewModel = _viewModel();
      await _aguardar();

      viewModel.novo();
      viewModel.alterarGrupo(viewModel.state.grupos.firstWhere((g) => g.nome == 'BARRA'));
      viewModel.descricaoController.text = 'Retangular';
      viewModel.alterarMedida(MedidaOrcamento.largura, pedir: true);
      await viewModel.salvar();
      await _aguardar();

      expect(viewModel.state.modo, MateriaisModo.edicao);
      expect(viewModel.state.selecionado?.nome, 'BARRA Retangular');
      expect(viewModel.state.selecionado?.medidas, {MedidaOrcamento.largura});
      expect(viewModel.state.tabela.temColunas, isFalse);
      viewModel.dispose();
    });

    test('não aceita material repetido no mesmo grupo', () async {
      final viewModel = _viewModel();
      await _aguardar();

      viewModel.novo();
      viewModel.alterarGrupo(viewModel.state.grupos.firstWhere((g) => g.nome == 'BARRA'));
      viewModel.descricaoController.text = 'redonda';
      await viewModel.salvar();

      expect(viewModel.state.aviso?.sucesso, isFalse);
      expect(viewModel.state.modo, MateriaisModo.novo);
      viewModel.dispose();
    });

    test('excluir tira o material da lista', () async {
      final viewModel = await _aberto('BARRA SEXTAVADA');

      await viewModel.excluir();

      expect(viewModel.state.modo, MateriaisModo.nenhum);
      expect(viewModel.state.materiais.any((m) => m.nome == 'BARRA SEXTAVADA'), isFalse);
      viewModel.dispose();
    });
  });

  group('Tabela de bitolas', () {
    test('adiciona uma linha no fim e edita outra', () async {
      final viewModel = await _aberto('BARRA REDONDA');

      expect(
        await viewModel.salvarLinha(const LinhaBitolaModel(valores: ['12"', '304,8', '572,8', ''])),
        isTrue,
      );
      expect(viewModel.state.tabela.linhas, hasLength(146));
      expect(viewModel.state.tabela.linhas.last.valor(0), '12"');

      final primeira = viewModel.state.tabela.linhas.first;
      await viewModel.salvarLinha(
        LinhaBitolaModel(codigo: primeira.codigo, valores: ['1/8"', '3,18', '0,06', '']),
      );
      expect(viewModel.state.tabela.linhas.first.valor(2), '0,06');
      viewModel.dispose();
    });

    test('não salva linha vazia', () async {
      final viewModel = await _aberto('BARRA REDONDA');

      expect(await viewModel.salvarLinha(const LinhaBitolaModel(valores: ['', ' '])), isFalse);
      expect(viewModel.state.aviso?.sucesso, isFalse);
      viewModel.dispose();
    });

    test('sobe, desce e exclui linhas', () async {
      final viewModel = await _aberto('BARRA REDONDA');
      final segunda = viewModel.state.tabela.linhas[1];

      await viewModel.moverLinha(segunda, -1);
      expect(viewModel.state.tabela.linhas.first, segunda);

      await viewModel.moverLinha(segunda, -1);
      expect(viewModel.state.tabela.linhas.first, segunda, reason: 'já é a primeira');

      await viewModel.excluirLinha(segunda);
      expect(viewModel.state.tabela.linhas, hasLength(144));
      expect(viewModel.state.tabela.linhas, isNot(contains(segunda)));
      viewModel.dispose();
    });

    test('remover uma coluna leva os valores e a coluna da bitola junto', () async {
      final viewModel = await _aberto('BARRA REDONDA');
      viewModel.alterarColunaBitola(1);

      // Tira "Diametro Pol", renomeia "area" e acrescenta "Preço".
      final salvou = await viewModel.salvarEstrutura(
        nome: 'Barra redonda',
        unidade: UnidadeTabela.kg,
        colunas: const [
          ColunaEdicao(nome: 'Diametro MM', origem: 1),
          ColunaEdicao(nome: 'kg / metro', origem: 2),
          ColunaEdicao(nome: 'Área', origem: 3),
          ColunaEdicao(nome: 'Preço'),
        ],
      );

      expect(salvou, isTrue);
      final tabela = viewModel.state.tabela;
      expect(tabela.colunas, ['Diametro MM', 'kg / metro', 'Área', 'Preço']);
      expect(tabela.unidade, UnidadeTabela.kg);
      expect(tabela.linhas.first.valores, ['3,18', '0,062', '0,0100', '']);
      expect(viewModel.state.colunaBitola, 0);
      viewModel.dispose();
    });

    test('a coluna da bitola volta a "nenhuma" se a coluna for removida', () async {
      final viewModel = await _aberto('BARRA REDONDA');

      await viewModel.salvarEstrutura(
        nome: '',
        unidade: UnidadeTabela.volume,
        colunas: const [ColunaEdicao(nome: 'Diametro MM', origem: 1)],
      );

      expect(viewModel.state.colunaBitola, isNull);
      viewModel.dispose();
    });

    test('busca na tabela pelo começo do valor', () async {
      final viewModel = await _aberto('BARRA REDONDA');

      viewModel.buscarNaTabela('12,7');

      expect(viewModel.state.linhasFiltradas.map((l) => l.valor(0)), ['1/2"']);
      viewModel.dispose();
    });
  });

  test('ColunaEdicao.remapear acompanha a coluna pela posição de origem', () {
    const colunas = [ColunaEdicao(nome: 'B', origem: 1), ColunaEdicao(nome: 'Nova')];
    expect(ColunaEdicao.remapear(1, colunas), 0);
    expect(ColunaEdicao.remapear(0, colunas), isNull);
    expect(ColunaEdicao.remapear(null, colunas), isNull);
  });
}
