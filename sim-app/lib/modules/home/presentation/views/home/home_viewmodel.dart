import 'package:core/core.dart';

import '../../../domain/domain.dart';
import 'home_state.dart';

class HomeViewModel extends ViewModel<HomeState> {
  HomeViewModel(this._repository, {DateTime Function()? agora})
    : _agora = agora ?? DateTime.now,
      super(HomeState.initial());

  final HomeRepository _repository;
  final DateTime Function() _agora;

  static const _extensoFeminino = [
    'nenhuma',
    'uma',
    'duas',
    'três',
    'quatro',
    'cinco',
    'seis',
    'sete',
    'oito',
    'nove',
    'dez',
  ];

  @override
  void initViewModel() {
    super.initViewModel();
    _definirCabecalho();
    carregarPainel();
  }

  void _definirCabecalho() {
    final agora = _agora();
    final saudacao = switch (agora.hour) {
      < 12 => 'Bom dia',
      < 18 => 'Boa tarde',
      _ => 'Boa noite',
    };
    emit(state.copyWith(saudacao: saudacao, dataHoje: agora.extenso.toCapitalized()));
  }

  Future<void> carregarPainel() async {
    emit(state.copyWith(isLoading: true, limparErro: true));

    final result = await _repository.carregarPainel();

    final newState = result.fold(
      (erro) => state.copyWith(mensagemErro: erro.message),
      (painel) => state.copyWith(painel: painel, view: _montarView(painel)),
    );
    emit(newState.copyWith(isLoading: false));
  }

  void alterarVisualizacao(HomeVisualizacaoEntregas visualizacao) {
    emit(state.copyWith(visualizacao: visualizacao));
  }

  HomePainelView _montarView(HomePainelModel painel) {
    final hoje = _agora().dateOnly;
    final amanha = DateTime(hoje.year, hoje.month, hoje.day + 1);

    final emUso = painel.maquinas.where((m) => m.emUso).toList();
    final capacidade = emUso.isEmpty
        ? 0.0
        : emUso.map((m) => m.ocupacao).reduce((a, b) => a + b) / emUso.length;

    final segunda = DateTime(hoje.year, hoje.month, hoje.day - (hoje.weekday - 1));
    final dias = [
      for (var i = 0; i < 7; i++)
        () {
          final data = DateTime(segunda.year, segunda.month, segunda.day + i);
          final doDia = painel.entregas.where((e) => e.dataEntrega.isSameDay(data)).toList()
            ..sort((a, b) => _prioridade(a.status).compareTo(_prioridade(b.status)));
          return HomeDiaSemana(data: data, entregas: doDia, hoje: data.isSameDay(hoje));
        }(),
    ];
    final daSemana = dias.expand((d) => d.entregas).toList();

    final emAndamento = painel.entregas.where((e) => !e.concluida).toList()
      ..sort((a, b) => a.dataEntrega.compareTo(b.dataEntrega));

    final ateAmanha = painel.entregas.where((e) {
      final data = e.dataEntrega.dateOnly;
      return !e.concluida && !data.isBefore(hoje) && !data.isAfter(amanha);
    }).length;

    return HomePainelView(
      capacidade: capacidade,
      maquinasEmUso: emUso.length,
      maquinasEmSobrecarga: emUso.where((m) => m.emSobrecarga).length,
      entregasAteAmanha: ateAmanha,
      fraseResumo: _fraseResumo(capacidade, emUso.length, painel.alertas),
      periodoSemana: _periodo(dias.first.data, dias.last.data),
      dias: dias,
      entregasNaSemana: daSemana.length,
      entregasConcluidasNaSemana: daSemana.where((e) => e.concluida).length,
      emAndamento: emAndamento.take(4).toList(),
    );
  }

  int _prioridade(EntregaStatus status) => switch (status) {
    EntregaStatus.atrasada => 0,
    EntregaStatus.pronta => 1,
    EntregaStatus.emProducao => 2,
    EntregaStatus.aguardandoMaterial => 3,
    EntregaStatus.entregue => 4,
  };

  String _fraseResumo(double capacidade, int maquinasEmUso, List<AlertaModel> alertas) {
    final ocupacao = maquinasEmUso == 0
        ? 'Nenhuma máquina está programada para hoje.'
        : 'A fábrica está com ${NumberFormatter.percentual(capacidade)} da capacidade programada para hoje.';

    String parte(int n, String singular, String plural) =>
        '${n <= 10 ? _extensoFeminino[n] : '$n'} ${n == 1 ? singular : plural}';

    final encomendas = alertas.where((a) => a.tipo.sobreEncomenda).length;
    final maquinas = alertas.length - encomendas;
    final partes = [
      if (encomendas > 0) parte(encomendas, 'encomenda', 'encomendas'),
      if (maquinas > 0) parte(maquinas, 'máquina', 'máquinas'),
    ];

    final atencao = switch (partes) {
      [] => 'Nada pede sua atenção por enquanto.',
      [final unica] => '${unica.toCapitalized()} ${alertas.length == 1 ? 'pede' : 'pedem'} sua atenção.',
      _ => '${partes.first.toCapitalized()} e ${partes.last} pedem sua atenção.',
    };

    return '$ocupacao $atencao';
  }

  String _periodo(DateTime inicio, DateTime fim) {
    final diaMesExtenso = DateFormat("d 'de' MMMM", 'pt_BR');
    if (inicio.month == fim.month) return '${inicio.day} a ${diaMesExtenso.format(fim)}';
    return '${diaMesExtenso.format(inicio)} a ${diaMesExtenso.format(fim)}';
  }
}
