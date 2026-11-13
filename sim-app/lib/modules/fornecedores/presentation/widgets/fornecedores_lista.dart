import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Lista de fornecedores com busca (painel esquerdo, como no sistema antigo).
class FornecedoresLista extends StatelessWidget {
  const FornecedoresLista({
    required this.fornecedores,
    required this.isLoading,
    required this.onBuscar,
    required this.onSelecionar,
    required this.onTentarNovamente,
    super.key,
    this.codigoSelecionado,
    this.erro,
  });

  final List<FornecedorModel> fornecedores;
  final bool isLoading;
  final int? codigoSelecionado;
  final String? erro;
  final ValueChanged<String> onBuscar;
  final ValueChanged<FornecedorModel> onSelecionar;
  final VoidCallback onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SimTokens.colorWhite,
        borderRadius: BorderRadius.circular(SimTokens.roundedLg),
        border: Border.all(color: SimTokens.colorBorder),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Spacing.sm.width),
            child: TextField(
              onChanged: onBuscar,
              textInputAction: TextInputAction.search,
              style: SimTypography.bodySmRegular,
              decoration: const InputDecoration(
                hintText: 'Buscar por nome, CNPJ ou cidade',
                constraints: BoxConstraints(minHeight: 44),
                prefixIcon: Icon(Icons.search, size: 20, color: SimTokens.colorNeutral500),
              ),
            ),
          ),
          const Divider(),
          Expanded(child: _conteudo()),
        ],
      ),
    );
  }

  Widget _conteudo() {
    if (erro != null) {
      return SimMensagem(
        icone: Icons.cloud_off_outlined,
        texto: erro!,
        acao: SimButton(
          label: 'Tentar novamente',
          style: SimButtonStyle.secundario,
          onPressed: onTentarNovamente,
        ),
      );
    }
    if (fornecedores.isEmpty) {
      return isLoading
          ? const Center(child: SimCircularLoading())
          : const SimMensagem(icone: Icons.search_off, texto: 'Nenhum fornecedor encontrado.');
    }

    return ListView.separated(
      padding: EdgeInsets.all(Spacing.xs.width),
      itemCount: fornecedores.length,
      separatorBuilder: (_, _) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        final fornecedor = fornecedores[index];
        return _ItemFornecedor(
          fornecedor: fornecedor,
          selecionado: fornecedor.codigo == codigoSelecionado,
          onTap: () => onSelecionar(fornecedor),
        );
      },
    );
  }
}

class _ItemFornecedor extends StatelessWidget {
  const _ItemFornecedor({required this.fornecedor, required this.selecionado, required this.onTap});

  final FornecedorModel fornecedor;
  final bool selecionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final detalhe = [fornecedor.nomeFantasia, fornecedor.cidadeUf].where((p) => p.isNotEmpty).join(' · ');
    final raio = BorderRadius.circular(SimTokens.roundedMd);

    return Semantics(
      selected: selecionado,
      button: true,
      child: Material(
        color: selecionado ? SimTokens.colorPrimary50 : SimTokens.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: raio,
          side: BorderSide(color: selecionado ? SimTokens.colorPrimary300 : SimTokens.transparent),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: raio,
          hoverColor: SimTokens.colorNeutral50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                SimAvatar(
                  iniciais: SimAvatar.iniciaisDe(fornecedor.razaoSocial),
                  size: 36,
                  background: selecionado ? SimTokens.colorPrimary100 : SimTokens.colorNeutral100,
                  foreground: selecionado ? SimTokens.colorPrimary900 : SimTokens.colorNeutral700,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fornecedor.razaoSocial,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: SimTypography.bodySmSemiBold.copyWith(
                          color: selecionado ? SimTokens.colorPrimary900 : null,
                        ),
                      ),
                      if (detalhe.isNotEmpty)
                        Text(
                          detalhe,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: SimTypography.bodyXsRegular,
                        ),
                      if (fornecedor.suspenso || fornecedor.inativo) ...[
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (fornecedor.suspenso)
                              const SimStatusChip(label: 'Suspenso', type: SimStatusType.alerta),
                            if (fornecedor.inativo) const SimStatusChip(label: 'Inativo'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (selecionado) const Icon(Icons.chevron_right, size: 20, color: SimTokens.colorPrimary500),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
