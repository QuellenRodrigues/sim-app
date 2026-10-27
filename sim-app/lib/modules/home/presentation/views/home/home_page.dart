import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../../../util/util.dart';
import '../../../home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ViewState<HomePage, HomeViewModel> {
  @override
  Widget build(BuildContext context) {
    final compacto = context.screenWidth < SimBreakpoints.compacto;

    return SimScaffold(
      body: ViewModelBuilder<HomeViewModel, HomeState>(
        viewModel: viewModel,
        builder: (context, state) {
          final view = state.view;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              compacto ? Spacing.sm.width : Spacing.lg.width,
              compacto ? Spacing.sm.height : Spacing.md.height + 4,
              compacto ? Spacing.sm.width : Spacing.lg.width,
              Spacing.xxl.height,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeDestaque(
                      dataHoje: state.dataHoje,
                      saudacao: state.saudacao,
                      fraseResumo: view?.fraseResumo,
                      capacidade: view?.capacidade,
                      maquinasEmUso: view?.maquinasEmUso ?? 0,
                      maquinasEmSobrecarga: view?.maquinasEmSobrecarga ?? 0,
                      entregasAteAmanha: view?.entregasAteAmanha ?? 0,
                      onNovoOrcamento: () => mostrarFuncionalidadeNaoImplementada(context),
                      onVerProgramacao: () => mostrarFuncionalidadeNaoImplementada(context),
                    ),
                    Spacing.md.vertical,
                    SimCircularLoading(
                      loading: state.isLoading,
                      child: _conteudo(state),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _conteudo(HomeState state) {
    final painel = state.painel;
    final view = state.view;
    if (state.mensagemErro != null || painel == null || view == null) {
      return HomeErro(
        mensagem: state.mensagemErro ?? 'Não foi possível carregar o painel.',
        onTentarNovamente: () => viewModel.carregarPainel(),
      );
    }

    final semana = HomeEntregasSemanaCard(
      periodo: view.periodoSemana,
      dias: view.dias,
      visualizacao: state.visualizacao,
      onVisualizacao: (visualizacao) => viewModel.alterarVisualizacao(visualizacao),
    );
    final emAndamento = HomeEmAndamentoCard(
      entregas: view.emAndamento,
      onVerEncomendas: () => mostrarFuncionalidadeNaoImplementada(context),
    );
    final atencao = HomeAtencaoCard(
      alertas: painel.alertas,
      onAcao: (_) => mostrarFuncionalidadeNaoImplementada(context),
    );
    final maquinas = HomeMaquinasCard(
      maquinas: painel.maquinas,
      onVerProgramacao: () => mostrarFuncionalidadeNaoImplementada(context),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeIndicadores(
          resumo: painel.resumo,
          maquinasEmUso: view.maquinasEmUso,
          entregasNaSemana: view.entregasNaSemana,
          entregasConcluidasNaSemana: view.entregasConcluidasNaSemana,
          onIndicador: (_) => mostrarFuncionalidadeNaoImplementada(context),
        ),
        Spacing.md.vertical,
        semana,
        Spacing.md.vertical,
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 1000) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [emAndamento, Spacing.md.vertical, atencao],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: emAndamento),
                Spacing.md.horizontal,
                Expanded(flex: 2, child: atencao),
              ],
            );
          },
        ),
        Spacing.md.vertical,
        maquinas,
      ],
    );
  }
}
