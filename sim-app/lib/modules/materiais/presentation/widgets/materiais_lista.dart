import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/domain.dart';

/// Lista de materiais agrupada por grupo, como a árvore Grupo › Subgrupo do sistema antigo.
class MateriaisLista extends StatelessWidget {
  const MateriaisLista({
    required this.materiais,
    required this.isLoading,
    required this.onBuscar,
    required this.onSelecionar,
    required this.onTentarNovamente,
    super.key,
    this.codigoSelecionado,
    this.erro,
  });

  final List<MaterialModel> materiais;
  final bool isLoading;
  final int? codigoSelecionado;
  final String? erro;
  final ValueChanged<String> onBuscar;
  final ValueChanged<MaterialModel> onSelecionar;
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
                hintText: 'Buscar material',
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
    if (materiais.isEmpty) {
      return isLoading
          ? const Center(child: SimCircularLoading())
          : const SimMensagem(icone: Icons.search_off, texto: 'Nenhum material encontrado.');
    }

    // Itens já vêm ordenados por grupo: um título antes do primeiro de cada grupo.
    final itens = <Widget>[];
    for (final (i, material) in materiais.indexed) {
      if (i == 0 || materiais[i - 1].grupo.codigo != material.grupo.codigo) {
        itens.add(
          Padding(
            padding: EdgeInsets.fromLTRB(12, i == 0 ? 8 : 16, 12, 6),
            child: Text(material.grupo.nome.toUpperCase(), style: SimTypography.labelXsSemiBold),
          ),
        );
      }
      itens.add(
        _ItemMaterial(
          material: material,
          selecionado: material.codigo == codigoSelecionado,
          onTap: () => onSelecionar(material),
        ),
      );
    }

    return ListView(padding: EdgeInsets.all(Spacing.xs.width), children: itens);
  }
}

class _ItemMaterial extends StatelessWidget {
  const _ItemMaterial({required this.material, required this.selecionado, required this.onTap});

  final MaterialModel material;
  final bool selecionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final raio = BorderRadius.circular(SimTokens.roundedMd);
    final bitolas = material.quantidadeBitolas;

    return Semantics(
      selected: selecionado,
      button: true,
      child: Material(
        color: selecionado ? SimTokens.colorPrimary50 : SimTokens.transparent,
        shape: RoundedRectangleBorder(borderRadius: raio),
        child: InkWell(
          onTap: onTap,
          borderRadius: raio,
          hoverColor: SimTokens.colorNeutral50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    material.descricao.isEmpty ? '(sem descrição)' : material.descricao,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: selecionado
                        ? SimTypography.bodySmSemiBold.copyWith(color: SimTokens.colorPrimary900)
                        : SimTypography.bodySmRegular,
                  ),
                ),
                if (bitolas > 0)
                  Text(
                    bitolas == 1 ? '1 bitola' : '$bitolas bitolas',
                    style: SimTypography.bodyXsRegular,
                  ),
                if (selecionado) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 20, color: SimTokens.colorPrimary500),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
