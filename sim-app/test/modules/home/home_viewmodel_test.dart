import 'package:app/modules/home/home.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

final _painel = HomePainelModel(
  resumo: const HomeResumoModel(
    orcamentosEmAberto: 3,
    valorOrcamentosEmAberto: 1000,
    encomendasEmProducao: 4,
    entregasNaSemana: 5,
    encomendasAtrasadas: 0,
  ),
  proximasEntregas: [
    EntregaModel(
      numero: '2026/0001',
      cliente: 'Cliente',
      item: 'Item',
      quantidade: 10,
      dataEntrega: DateTime(2026, 10, 15),
      status: EntregaStatus.emProducao,
    ),
  ],
  cargaMaquinas: const [CargaMaquinaModel(maquina: 'Torno', ocupacao: 0.5)],
);

class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository(this.resultados);

  /// Respostas devolvidas em sequência, uma por chamada.
  final List<Either<BaseException, HomePainelModel>> resultados;
  int chamadas = 0;

  @override
  Future<Either<BaseException, HomePainelModel>> carregarPainel() async => resultados[chamadas++];
}

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  group('HomeViewModel', () {
    test('carrega o painel ao iniciar', () async {
      final repository = _FakeHomeRepository([Right(_painel)]);
      final viewModel = HomeViewModel(repository);

      expect(viewModel.state.isLoading, isTrue);
      await pumpEventQueue();

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.painel, _painel);
      expect(viewModel.state.mensagemErro, isNull);
      viewModel.dispose();
    });

    test('exibe a mensagem de erro do repository e recupera ao tentar de novo', () async {
      final repository = _FakeHomeRepository([
        Left(DomainException(message: 'Falhou')),
        Right(_painel),
      ]);
      final viewModel = HomeViewModel(repository);
      await pumpEventQueue();

      expect(viewModel.state.mensagemErro, 'Falhou');
      expect(viewModel.state.painel, isNull);

      await viewModel.carregarPainel();

      expect(viewModel.state.mensagemErro, isNull);
      expect(viewModel.state.painel, _painel);
      expect(repository.chamadas, 2);
      viewModel.dispose();
    });

    test('define saudação e data conforme o horário', () async {
      final manha = HomeViewModel(
        _FakeHomeRepository([Right(_painel)]),
        agora: () => DateTime(2026, 10, 14, 9),
      );
      final noite = HomeViewModel(
        _FakeHomeRepository([Right(_painel)]),
        agora: () => DateTime(2026, 10, 14, 20),
      );
      await pumpEventQueue();

      expect(manha.state.saudacao, 'Bom dia');
      expect(manha.state.dataHoje, 'Quarta-feira, 14 de outubro');
      expect(noite.state.saudacao, 'Boa noite');
      manha.dispose();
      noite.dispose();
    });
  });
}
