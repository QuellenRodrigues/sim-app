import 'package:app/modules/fornecedores/fornecedores.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Espera a lista recarregar (o datasource de exemplo simula a latência da rede).
Future<void> _aguardarDatasource() => Future<void>.delayed(const Duration(milliseconds: 400));

final _agora = DateTime(2026, 11, 5, 10);

FornecedoresViewModel _viewModel() =>
    FornecedoresViewModel(FornecedoresRepositoryImpl(FornecedoresDatasourceMock(agora: () => _agora)));

FornecedorModel _porCodigo(FornecedoresViewModel viewModel, int codigo) =>
    viewModel.state.fornecedores.firstWhere((f) => f.codigo == codigo);

void main() {
  setUp(FornecedoresDatasourceMock.reiniciar);

  group('FornecedoresViewModel', () {
    test('carrega os fornecedores em ordem alfabética, com suspensos e inativos', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      expect(viewModel.state.fornecedores, hasLength(7));
      expect(viewModel.state.fornecedores.first.razaoSocial, 'Aços Serra da Mantiqueira Ltda.');
      expect(_porCodigo(viewModel, 5).suspenso, isTrue);
      expect(_porCodigo(viewModel, 7).inativo, isTrue);
      viewModel.dispose();
    });

    test('busca por nome sem acento, por CNPJ, por cidade e por contato', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      for (final (busca, codigo) in [
        ('transmissoes', 4),
        ('15.748.916', 2),
        ('Ipatinga', 2),
        ('Beatriz', 6),
      ]) {
        viewModel.buscar(busca, espera: Duration.zero);
        await _aguardarDatasource();
        expect(viewModel.state.fornecedores.map((f) => f.codigo), [codigo], reason: busca);
      }
      viewModel.dispose();
    });

    test('selecionar preenche o formulário e carrega os materiais', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.selecionar(_porCodigo(viewModel, 2));
      expect(viewModel.emailController.text, 'comercial@tubosvale.com.br');
      expect(viewModel.state.estado, UnidadeFederativa.mg);
      await _aguardarDatasource();

      expect(viewModel.state.materiais.map((m) => m.nome), contains('TUBO SCH. 40'));
      expect(viewModel.state.materiais, hasLength(5));
      viewModel.dispose();
    });

    test('novo fornecedor recebe o próximo código e continua aberto para edição', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.novo();
      viewModel.razaoSocialController.text = 'Ferragens Nova Era Ltda.';
      viewModel.cnpjController.text = '88.640.420/0001-83';
      await viewModel.salvar();

      expect(viewModel.state.aviso?.sucesso, isTrue);
      expect(viewModel.state.modo, FornecedoresModo.edicao);
      expect(viewModel.state.selecionado?.codigo, 8);
      viewModel.dispose();
    });

    test('não salva fornecedor com CNPJ já cadastrado', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.novo();
      viewModel.razaoSocialController.text = 'Outra empresa';
      viewModel.cnpjController.text = '10.275.958/0001-49';
      await viewModel.salvar();

      expect(viewModel.state.aviso?.sucesso, isFalse);
      expect(viewModel.state.aviso?.texto, contains('Mantiqueira'));
      expect(viewModel.state.modo, FornecedoresModo.novo);
      viewModel.dispose();
    });

    test('suspende com a data de hoje e retira a suspensão, sem perder o que foi digitado', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.selecionar(_porCodigo(viewModel, 1));
      viewModel.contatoController.text = 'Ainda não salvo';
      await viewModel.alternarSuspensao();

      expect(viewModel.state.selecionado?.suspensoEm, _agora);
      expect(_porCodigo(viewModel, 1).suspensoEm, _agora);
      expect(viewModel.contatoController.text, 'Ainda não salvo');

      await viewModel.alternarSuspensao();

      expect(viewModel.state.selecionado?.suspenso, isFalse);
      expect(_porCodigo(viewModel, 1).suspenso, isFalse);
      viewModel.dispose();
    });

    test('salvar mantém a suspensão e grava o inativo', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.selecionar(_porCodigo(viewModel, 5));
      viewModel.alterarInativo(true);
      await viewModel.salvar();

      expect(_porCodigo(viewModel, 5).inativo, isTrue);
      expect(_porCodigo(viewModel, 5).suspensoEm, DateTime(2026, 9, 21));
      viewModel.dispose();
    });

    test('adiciona e remove materiais na hora, sem oferecer os que já tem', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();
      viewModel.selecionar(_porCodigo(viewModel, 4));
      await _aguardarDatasource();
      expect(viewModel.state.materiais, hasLength(3));

      final disponiveis = await viewModel.materiaisDisponiveis();
      expect(disponiveis!.map((m) => m.codigo), isNot(contains(70)));

      await viewModel.adicionarMateriais([disponiveis.first.codigo]);
      expect(viewModel.state.materiais, hasLength(4));

      await viewModel.removerMaterial(viewModel.state.materiais.firstWhere((m) => m.codigo == 70));
      expect(viewModel.state.materiais.map((m) => m.codigo), isNot(contains(70)));
      viewModel.dispose();
    });

    test('carrega os preços do fornecedor e salva um novo com a data de hoje', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();
      viewModel.selecionar(_porCodigo(viewModel, 4));
      await _aguardarDatasource();
      expect(viewModel.state.precos, hasLength(2));

      final salvou = await viewModel.salvarPreco(
        PrecoMaterialModel(
          codigoFornecedor: 4,
          material: viewModel.state.materiais.firstWhere((m) => m.codigo == 70),
          especificacao: ' 6205 ZZ ',
          unidade: 'UN',
          preco: 32.5,
        ),
      );

      expect(salvou, isTrue);
      final novo = viewModel.state.precos.firstWhere((p) => p.especificacao == '6205 ZZ');
      expect(novo.data, _agora);
      viewModel.dispose();
    });

    test('não aceita dois preços do mesmo fornecedor para o mesmo item', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();
      viewModel.selecionar(_porCodigo(viewModel, 4));
      await _aguardarDatasource();
      final existente = viewModel.state.precos.first;

      final salvou = await viewModel.salvarPreco(
        PrecoMaterialModel(
          codigoFornecedor: 4,
          material: existente.material,
          especificacao: existente.especificacao.toLowerCase(),
          unidade: 'UN',
          preco: 1,
        ),
      );

      expect(salvou, isFalse);
      expect(viewModel.state.aviso?.sucesso, isFalse);
      expect(viewModel.state.precos, hasLength(2));
      viewModel.dispose();
    });

    test('remover o material apaga os preços dele', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();
      viewModel.selecionar(_porCodigo(viewModel, 2));
      await _aguardarDatasource();
      expect(viewModel.state.precos, hasLength(1));

      await viewModel.removerMaterial(viewModel.state.materiais.firstWhere((m) => m.codigo == 12));

      expect(viewModel.state.precos, isEmpty);
      viewModel.dispose();
    });

    test('novo não herda os dados do fornecedor aberto', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();
      viewModel.selecionar(_porCodigo(viewModel, 7));
      await _aguardarDatasource();

      viewModel.novo();

      expect(viewModel.state.selecionado, isNull);
      expect(viewModel.state.inativo, isFalse);
      expect(viewModel.state.materiais, isEmpty);
      expect(viewModel.state.precos, isEmpty);
      expect(viewModel.razaoSocialController.text, isEmpty);
      viewModel.dispose();
    });
  });
}
