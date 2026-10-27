import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Lista de clientes com busca (painel esquerdo, como a árvore do sistema antigo).
class ClientesLista extends StatelessWidget {
  const ClientesLista({
    required this.clientes,
    required this.isLoading,
    required this.onBuscar,
    required this.onSelecionar,
    required this.onTentarNovamente,
    super.key,
    this.codigoSelecionado,
    this.erro,
  });

  final List<ClienteModel> clientes;
  final bool isLoading;
  final int? codigoSelecionado;
  final String? erro;
  final ValueChanged<String> onBuscar;
  final ValueChanged<ClienteModel> onSelecionar;
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
      return _Mensagem(
        icone: Icons.cloud_off_outlined,
        texto: erro!,
        acao: SimButton(
          label: 'Tentar novamente',
          style: SimButtonStyle.secundario,
          onPressed: onTentarNovamente,
        ),
      );
    }
    if (clientes.isEmpty) {
      return isLoading
          ? const Center(child: SimCircularLoading())
          : const _Mensagem(icone: Icons.search_off, texto: 'Nenhum cliente encontrado.');
    }

    return ListView.separated(
      padding: EdgeInsets.all(Spacing.xs.width),
      itemCount: clientes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        final cliente = clientes[index];
        return _ItemCliente(
          cliente: cliente,
          selecionado: cliente.codigo == codigoSelecionado,
          onTap: () => onSelecionar(cliente),
        );
      },
    );
  }
}

class _ItemCliente extends StatelessWidget {
  const _ItemCliente({required this.cliente, required this.selecionado, required this.onTap});

  final ClienteModel cliente;
  final bool selecionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final detalhe = [cliente.nomeFantasia, cliente.cidadeUf].where((p) => p.isNotEmpty).join(' · ');
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
                  iniciais: SimAvatar.iniciaisDe(cliente.razaoSocial),
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
                        cliente.razaoSocial,
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

class _Mensagem extends StatelessWidget {
  const _Mensagem({required this.icone, required this.texto, this.acao});

  final IconData icone;
  final String texto;
  final Widget? acao;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Spacing.md.width),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 32, color: SimTokens.colorNeutral400),
            Spacing.xs.vertical,
            Text(
              texto,
              textAlign: TextAlign.center,
              style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral600),
            ),
            if (acao != null) ...[Spacing.sm.vertical, acao!],
          ],
        ),
      ),
    );
  }
}
