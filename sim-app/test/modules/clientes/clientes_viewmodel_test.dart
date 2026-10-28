import 'package:app/modules/clientes/clientes.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Espera a lista recarregar (o datasource de exemplo simula a latência da rede).
Future<void> _aguardarDatasource() => Future<void>.delayed(const Duration(milliseconds: 400));

ClientesViewModel _viewModel() => ClientesViewModel(ClientesRepositoryImpl(ClientesDatasourceMock()));

void main() {
  setUp(ClientesDatasourceMock.reiniciar);

  group('ClientesViewModel', () {
    test('carrega os clientes em ordem alfabética ao iniciar', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.clientes, hasLength(8));
      expect(viewModel.state.clientes.first.razaoSocial, 'Automação Taubaté Ltda.');
      viewModel.dispose();
    });

    test('busca por nome sem acento, por CNPJ e por cidade', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.buscar('metalurgica', espera: Duration.zero);
      await _aguardarDatasource();
      expect(viewModel.state.clientes.map((c) => c.codigo), [1]);

      viewModel.buscar('44.555.666', espera: Duration.zero);
      await _aguardarDatasource();
      expect(viewModel.state.clientes.map((c) => c.codigo), [2]);

      viewModel.buscar('Resende', espera: Duration.zero);
      await _aguardarDatasource();
      expect(viewModel.state.clientes.map((c) => c.codigo), [4]);
      viewModel.dispose();
    });

    test('selecionar preenche o formulário', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();
      final cliente = viewModel.state.clientes.firstWhere((c) => c.codigo == 2);

      viewModel.selecionar(cliente);

      expect(viewModel.state.modo, ClientesModo.edicao);
      expect(viewModel.razaoSocialController.text, 'Usinagem Rio Claro S.A.');
      expect(viewModel.cnpjController.text, '44.555.666/0001-81');
      expect(viewModel.faxController.text, '(24) 3348-2021');
      expect(viewModel.state.estado, UnidadeFederativa.rj);
      viewModel.dispose();
    });

    test('novo cliente recebe o próximo código e continua aberto para edição', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.novo();
      expect(viewModel.razaoSocialController.text, isEmpty);
      viewModel.razaoSocialController.text = 'Tornearia Nova Era Ltda.';
      viewModel.cnpjController.text = '11.444.777/0001-61';
      viewModel.alterarEstado(UnidadeFederativa.mg);
      await viewModel.salvar();

      expect(viewModel.state.aviso?.sucesso, isTrue);
      expect(viewModel.state.modo, ClientesModo.edicao);
      expect(viewModel.state.selecionado?.codigo, 9);
      expect(viewModel.state.selecionado?.estado, UnidadeFederativa.mg);
      expect(viewModel.state.clientes, hasLength(9));
      viewModel.dispose();
    });

    test('não salva cliente com CNPJ já cadastrado', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.novo();
      viewModel.razaoSocialController.text = 'Outra empresa';
      viewModel.cnpjController.text = '11.222.333/0001-81';
      await viewModel.salvar();

      expect(viewModel.state.aviso?.sucesso, isFalse);
      expect(viewModel.state.aviso?.texto, contains('Metalúrgica Vale Verde'));
      expect(viewModel.state.modo, ClientesModo.novo);
      expect(viewModel.state.clientes, hasLength(8));
      viewModel.dispose();
    });

    test('altera um cliente existente', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.selecionar(viewModel.state.clientes.firstWhere((c) => c.codigo == 3));
      viewModel.contatoController.text = 'Ana Souza';
      await viewModel.salvar();

      final alterado = viewModel.state.clientes.firstWhere((c) => c.codigo == 3);
      expect(alterado.contato, 'Ana Souza');
      expect(viewModel.state.clientes, hasLength(8));
      viewModel.dispose();
    });

    test('excluir remove o cliente e fecha o formulário', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.selecionar(viewModel.state.clientes.firstWhere((c) => c.codigo == 5));
      await viewModel.excluir();

      expect(viewModel.state.aviso?.texto, 'Cliente excluído com sucesso!');
      expect(viewModel.state.modo, ClientesModo.nenhum);
      expect(viewModel.state.clientes.any((c) => c.codigo == 5), isFalse);
      viewModel.dispose();
    });

    test('excluído não bloqueia o CNPJ e não recebe o código de volta', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.selecionar(viewModel.state.clientes.firstWhere((c) => c.codigo == 8));
      await viewModel.excluir();
      viewModel.novo();
      viewModel.razaoSocialController.text = 'Automação Taubaté Ltda.';
      viewModel.cnpjController.text = '19.283.746/0001-88';
      await viewModel.salvar();

      expect(viewModel.state.aviso?.sucesso, isTrue);
      expect(viewModel.state.selecionado?.codigo, 9);
      viewModel.dispose();
    });

    test('cliente novo começa com os impostos padrão do SIM', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.selecionar(viewModel.state.clientes.firstWhere((c) => c.codigo == 2));
      viewModel.novo();

      expect(viewModel.state.icms, TributacaoImposto.aParte);
      expect(viewModel.state.destinacaoIcms, DestinacaoIcms.usoConsumo);
      expect(viewModel.state.ipi, TributacaoImposto.aParte);
      expect(viewModel.state.iss, TributacaoImposto.incluso);
      expect(viewModel.aliquotaIssController.text, isEmpty);
      viewModel.dispose();
    });

    test('salva inscrições, e-mails extras e impostos', () async {
      final viewModel = _viewModel();
      await _aguardarDatasource();

      viewModel.selecionar(viewModel.state.clientes.firstWhere((c) => c.codigo == 8));
      expect(viewModel.aliquotaIssController.text, '5');

      viewModel.inscricaoEstadualController.text = '123.456.789.110';
      viewModel.email3Controller.text = 'nf@autotaubate.com.br';
      viewModel.alterarIcms(TributacaoImposto.naoIncidente);
      viewModel.alterarDestinacaoIcms(DestinacaoIcms.industrializacao);
      viewModel.alterarIpi(TributacaoImposto.incluso);
      viewModel.aliquotaIssController.text = '2,5';
      await viewModel.salvar();

      final salvo = viewModel.state.clientes.firstWhere((c) => c.codigo == 8);
      expect(salvo.inscricaoEstadual, '123.456.789.110');
      expect(salvo.inscricaoMunicipal, '45.210-7');
      expect(salvo.email3, 'nf@autotaubate.com.br');
      expect(salvo.icms, TributacaoImposto.naoIncidente);
      expect(salvo.destinacaoIcms, DestinacaoIcms.industrializacao);
      expect(salvo.ipi, TributacaoImposto.incluso);
      expect(salvo.iss, TributacaoImposto.aParte);
      expect(salvo.aliquotaIss, closeTo(0.025, 1e-9));
      expect(viewModel.aliquotaIssController.text, '2,5');
      viewModel.dispose();
    });
  });

  group('AliquotaIcms', () {
    test('usa a tabela de ICMS por estado do SIM antigo', () {
      expect(AliquotaIcms.de(UnidadeFederativa.rj), 0.19);
      expect(AliquotaIcms.de(UnidadeFederativa.es), 0.07);
      expect(AliquotaIcms.de(UnidadeFederativa.sp), 0.12);
      expect(AliquotaIcms.de(UnidadeFederativa.to), isNull);
      expect(AliquotaIcms.de(null), isNull);
    });
  });
}
