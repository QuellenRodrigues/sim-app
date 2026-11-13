import 'package:app/modules/fornecedores/fornecedores.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

FornecedoresDatasourceMock _datasource() => FornecedoresDatasourceMock(agora: () => DateTime(2026, 11, 5));

PrecosConsultaViewModel _viewModel() => PrecosConsultaViewModel(FornecedoresRepositoryImpl(_datasource()));

Future<void> _buscar(PrecosConsultaViewModel viewModel, String texto) async {
  viewModel.buscar(texto, espera: Duration.zero);
  await Future<void>.delayed(const Duration(milliseconds: 350));
}

void main() {
  setUp(FornecedoresDatasourceMock.reiniciar);

  group('PrecosConsultaViewModel', () {
    test('parafuso m10 mostra quem fornece, do menor para o maior preço', () async {
      final viewModel = _viewModel();

      await _buscar(viewModel, 'parafuso m10');

      final grupo = viewModel.state.grupos.single;
      expect(grupo.nome, 'MAT. COMERCIAL PARAFUSO M10 x 50 ZINCADO');
      expect(grupo.ofertas.map((o) => o.preco.preco), [1.62, 1.85]);
      expect(grupo.ofertas.first.fornecedor.nomeFantasia, 'Perfis Campo Belo');
      expect(grupo.menorPreco, 1.62);
      viewModel.dispose();
    });

    test('inclui quem fornece o material mas não tem preço para o item', () async {
      final viewModel = _viewModel();

      await _buscar(viewModel, 'parafuso m10');

      expect(viewModel.state.grupos.single.semPreco.map((f) => f.nomeFantasia), ['Aços Mantiqueira']);
      viewModel.dispose();
    });

    test('procurar só "parafuso" traz cada especificação em separado, sem diferenciar acentos', () async {
      final viewModel = _viewModel();

      await _buscar(viewModel, 'PARAFUSÓ');

      expect(viewModel.state.grupos.map((g) => g.especificacao), ['M10 x 50 ZINCADO', 'M12 x 80 INOX']);
      viewModel.dispose();
    });

    test('material sem nenhum preço aparece com os fornecedores', () async {
      final viewModel = _viewModel();

      await _buscar(viewModel, 'ultra som');

      final grupo = viewModel.state.grupos.single;
      expect(grupo.ofertas, isEmpty);
      expect(grupo.menorPreco, isNull);
      expect(grupo.semPreco.single.nomeFantasia, 'Lab Ensaios Resende');
      viewModel.dispose();
    });

    test('deixa os fornecedores inativos de fora, mas mantém os suspensos', () async {
      final viewModel = _viewModel();

      await _buscar(viewModel, 'frete');
      expect(viewModel.state.grupos, isEmpty);

      await _buscar(viewModel, 'trat');
      expect(viewModel.state.grupos.single.semPreco.single.suspenso, isTrue);
      viewModel.dispose();
    });

    test('preço salvo no fornecedor aparece na consulta', () async {
      final viewModel = _viewModel();
      await _datasource().salvarPreco(
        const PrecoMaterialModel(
          codigoFornecedor: 1,
          material: MaterialFornecidoModel(codigo: 14, tipo: 'MAT. COMERCIAL', descricao: 'PARAFUSO'),
          especificacao: 'm10 X 50 zincado',
          unidade: 'UN',
          preco: 1.5,
        ),
      );

      await _buscar(viewModel, 'parafuso m10');

      final grupo = viewModel.state.grupos.single;
      expect(grupo.ofertas.first.fornecedor.nomeFantasia, 'Aços Mantiqueira');
      expect(grupo.semPreco, isEmpty);
      viewModel.dispose();
    });

    test('busca vazia limpa o resultado', () async {
      final viewModel = _viewModel();
      await _buscar(viewModel, 'parafuso');

      await _buscar(viewModel, '   ');

      expect(viewModel.state.grupos, isEmpty);
      viewModel.dispose();
    });
  });
}
