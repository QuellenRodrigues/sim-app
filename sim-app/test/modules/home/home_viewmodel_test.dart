import 'package:app/modules/home/home.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

/// Quarta-feira, 14/10/2026, 15h.
final _agora = DateTime(2026, 10, 14, 15);

EntregaModel _entrega(String numero, DateTime data, EntregaStatus status) => EntregaModel(
  numero: numero,
  cliente: 'Cliente $numero',
  item: 'Item',
  quantidade: 10,
  dataEntrega: data,
  status: status,
  etapa: 'Torneamento',
  progresso: 0.5,
);

final _painel = HomePainelModel(
  resumo: const HomeResumoModel(
    orcamentosEmAberto: 3,
    valorOrcamentosEmAberto: 1000,
    orcamentosNovosNaSemana: 1,
    tendenciaOrcamentos: [1, 2, 3],
    encomendasEmProducao: 4,
    ordensProducaoAbertas: 5,
    tendenciaProducao: [1, 2, 3],
    encomendasAtrasadas: 1,
    diasAtrasoMaisAntiga: 2,
    tendenciaAtrasos: [0, 1, 1],
  ),
  entregas: [
    _entrega('A', DateTime(2026, 10, 12), EntregaStatus.atrasada),
    _entrega('B', DateTime(2026, 10, 13), EntregaStatus.entregue),
    _entrega('C', DateTime(2026, 10, 14), EntregaStatus.pronta),
    _entrega('D', DateTime(2026, 10, 15), EntregaStatus.emProducao),
    _entrega('E', DateTime(2026, 10, 20), EntregaStatus.emProducao),
  ],
  maquinas: const [
    MaquinaModel(nome: 'Torno', situacao: SituacaoMaquina.operando, ocupacao: 0.6),
    MaquinaModel(nome: 'Centro', situacao: SituacaoMaquina.operando, ocupacao: 1.2),
    MaquinaModel(nome: 'Serra', situacao: SituacaoMaquina.parada, ocupacao: 0),
  ],
  alertas: const [
    AlertaModel(tipo: TipoAlerta.atraso, titulo: 'Atraso', descricao: '', acao: ''),
    AlertaModel(tipo: TipoAlerta.materialPendente, titulo: 'Material', descricao: '', acao: ''),
    AlertaModel(tipo: TipoAlerta.sobrecarga, titulo: 'Sobrecarga', descricao: '', acao: ''),
  ],
);

class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository(this.resultados);

  /// Respostas devolvidas em sequência, uma por chamada.
  final List<Either<BaseException, HomePainelModel>> resultados;
  int chamadas = 0;

  @override
  Future<Either<BaseException, HomePainelModel>> carregarPainel() async => resultados[chamadas++];
}

HomeViewModel _viewModel(List<Either<BaseException, HomePainelModel>> resultados, {DateTime? agora}) =>
    HomeViewModel(_FakeHomeRepository(resultados), agora: () => agora ?? _agora);

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  group('HomeViewModel', () {
    test('carrega o painel ao iniciar', () async {
      final viewModel = _viewModel([Right(_painel)]);

      expect(viewModel.state.isLoading, isTrue);
      await pumpEventQueue();

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.painel, _painel);
      expect(viewModel.state.view, isNotNull);
      expect(viewModel.state.mensagemErro, isNull);
      viewModel.dispose();
    });

    test('exibe a mensagem de erro do repository e recupera ao tentar de novo', () async {
      final repository = _FakeHomeRepository([Left(DomainException(message: 'Falhou')), Right(_painel)]);
      final viewModel = HomeViewModel(repository, agora: () => _agora);
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
      final manha = _viewModel([Right(_painel)], agora: DateTime(2026, 10, 14, 9));
      final noite = _viewModel([Right(_painel)], agora: DateTime(2026, 10, 14, 20));
      await pumpEventQueue();

      expect(manha.state.saudacao, 'Bom dia');
      expect(manha.state.dataHoje, 'Quarta-feira, 14 de outubro');
      expect(noite.state.saudacao, 'Boa noite');
      manha.dispose();
      noite.dispose();
    });

    test('calcula capacidade e máquinas considerando só as que estão em uso', () async {
      final viewModel = _viewModel([Right(_painel)]);
      await pumpEventQueue();
      final view = viewModel.state.view!;

      expect(view.capacidade, closeTo(0.9, 0.0001));
      expect(view.maquinasEmUso, 2);
      expect(view.maquinasEmSobrecarga, 1);
      viewModel.dispose();
    });

    test('monta a semana de segunda a domingo com as entregas de cada dia', () async {
      final viewModel = _viewModel([Right(_painel)]);
      await pumpEventQueue();
      final view = viewModel.state.view!;

      expect(view.periodoSemana, '12 a 18 de outubro');
      expect(view.dias.map((d) => d.data.day), [12, 13, 14, 15, 16, 17, 18]);
      expect(view.dias.where((d) => d.hoje).single.data.day, 14);
      expect(view.dias[0].entregas.single.numero, 'A');
      expect(view.entregasNaSemana, 4);
      expect(view.entregasConcluidasNaSemana, 1);
      expect(view.entregasAteAmanha, 2);
      viewModel.dispose();
    });

    test('lista em andamento só as não entregues, da mais urgente para a menos', () async {
      final viewModel = _viewModel([Right(_painel)]);
      await pumpEventQueue();

      expect(viewModel.state.view!.emAndamento.map((e) => e.numero), ['A', 'C', 'D', 'E']);
      viewModel.dispose();
    });

    test('resume a capacidade e o que pede atenção em uma frase', () async {
      final viewModel = _viewModel([Right(_painel)]);
      await pumpEventQueue();

      expect(
        viewModel.state.view!.fraseResumo,
        'A fábrica está com 90% da capacidade programada para hoje. '
        'Duas encomendas e uma máquina pedem sua atenção.',
      );
      viewModel.dispose();
    });

    test('alterna entre semana e lista', () async {
      final viewModel = _viewModel([Right(_painel)]);
      await pumpEventQueue();

      viewModel.alterarVisualizacao(HomeVisualizacaoEntregas.lista);

      expect(viewModel.state.visualizacao, HomeVisualizacaoEntregas.lista);
      viewModel.dispose();
    });
  });
}
