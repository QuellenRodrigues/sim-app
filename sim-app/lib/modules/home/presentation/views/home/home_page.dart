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
    return SimScaffold(
      body: ViewModelBuilder<HomeViewModel, HomeState>(
        viewModel: viewModel,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.screenWidth < SimBreakpoints.compacto ? Spacing.sm.width : Spacing.lg.width,
              vertical: Spacing.md.height,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeCabecalho(
                      saudacao: state.saudacao,
                      dataHoje: state.dataHoje,
                      onNovoOrcamento: () => mostrarFuncionalidadeNaoImplementada(context),
                      onNovaEncomenda: () => mostrarFuncionalidadeNaoImplementada(context),
                    ),
                    Spacing.md.vertical,
                    SimCircularLoading(
                      loading: state.isLoading,
                      child: _conteudo(state),
                    ),
                    Spacing.lg.vertical,
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
    if (state.mensagemErro != null || painel == null) {
      return HomeErro(
        mensagem: state.mensagemErro ?? 'Não foi possível carregar o painel.',
        onTentarNovamente: () => viewModel.carregarPainel(),
      );
    }

    final entregas = HomeProximasEntregasCard(
      entregas: painel.proximasEntregas,
      onVerEncomendas: () => mostrarFuncionalidadeNaoImplementada(context),
    );
    final lateral = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeCargaMaquinasCard(
          cargas: painel.cargaMaquinas,
          onVerProgramacao: () => mostrarFuncionalidadeNaoImplementada(context),
        ),
        Spacing.sm.vertical,
        HomeAtalhosCard(onAtalho: (_) => mostrarFuncionalidadeNaoImplementada(context)),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HomeIndicadores(
          resumo: painel.resumo,
          onIndicador: (_) => mostrarFuncionalidadeNaoImplementada(context),
        ),
        Spacing.sm.vertical,
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 1000) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [entregas, Spacing.sm.vertical, lateral],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: entregas),
                Spacing.sm.horizontal,
                Expanded(flex: 2, child: lateral),
              ],
            );
          },
        ),
      ],
    );
  }
}
