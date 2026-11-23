import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../fornecedores.dart';

/// Procura um material e mostra quem fornece, com os preços do menor para o maior.
class PrecosConsultaPage extends StatefulWidget {
  const PrecosConsultaPage({super.key});

  static const rota = '/menu/cadastros/fornecedores/precos/';

  @override
  State<PrecosConsultaPage> createState() => _PrecosConsultaPageState();
}

class _PrecosConsultaPageState extends ViewState<PrecosConsultaPage, PrecosConsultaViewModel> {
  @override
  Widget build(BuildContext context) {
    final compacto = context.screenWidth < SimBreakpoints.compacto;

    return SimScaffold(
      body: ViewModelBuilder<PrecosConsultaViewModel, PrecosConsultaState>(
        viewModel: viewModel,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              compacto ? Spacing.sm.width : Spacing.lg.width,
              compacto ? Spacing.sm.height : Spacing.md.height + 4,
              compacto ? Spacing.sm.width : Spacing.lg.width,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Voltar para fornecedores',
                      onPressed: () => Nav.navigate('/menu/cadastros/fornecedores/'),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Spacing.xs.horizontal,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FORNECEDORES', style: SimTypography.overlineSemiBold),
                          Text('Consulta de preços', style: SimTypography.titleXlMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacing.sm.vertical,
                TextField(
                  autofocus: true,
                  onChanged: (texto) => viewModel.buscar(texto),
                  textInputAction: TextInputAction.search,
                  style: SimTypography.bodySmRegular,
                  decoration: const InputDecoration(
                    hintText: 'Procure um material. Ex.: parafuso m10',
                    constraints: BoxConstraints(minHeight: 44),
                    prefixIcon: Icon(Icons.search, size: 20, color: SimTokens.colorNeutral500),
                  ),
                ),
                Spacing.sm.vertical,
                Expanded(child: _resultado(state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _resultado(PrecosConsultaState state) {
    if (state.erro != null) {
      return SimMensagem(
        icone: Icons.cloud_off_outlined,
        texto: state.erro!,
        acao: SimButton(
          label: 'Tentar novamente',
          style: SimButtonStyle.secundario,
          onPressed: () => viewModel.consultar(),
        ),
      );
    }
    if (state.busca.trim().isEmpty) {
      return const SimMensagem(
        icone: Icons.price_check,
        texto: 'Digite o nome do material para ver os fornecedores e os preços.',
      );
    }
    if (state.grupos.isEmpty) {
      return state.isLoading
          ? const Center(child: SimCircularLoading())
          : const SimMensagem(
              icone: Icons.search_off,
              texto: 'Nenhum fornecedor encontrado para este item.',
            );
    }

    return ListView.separated(
      padding: EdgeInsets.only(bottom: Spacing.md.height),
      itemCount: state.grupos.length,
      separatorBuilder: (_, _) => Spacing.sm.vertical,
      itemBuilder: (context, index) => GrupoPrecosCard(grupo: state.grupos[index]),
    );
  }
}
