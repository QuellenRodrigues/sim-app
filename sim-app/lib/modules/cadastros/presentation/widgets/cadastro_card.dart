import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../utils/cadastros_enum.dart';

/// Atalho para um cadastro; os que ainda não foram migrados aparecem como "Em breve".
class CadastroCard extends StatelessWidget {
  const CadastroCard({required this.cadastro, required this.onTap, super.key});

  final CadastrosEnum cadastro;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final disponivel = cadastro.disponivel;
    final raio = BorderRadius.circular(SimTokens.roundedLg);

    return Material(
      color: SimTokens.colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: raio,
        side: const BorderSide(color: SimTokens.colorBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: raio,
        hoverColor: SimTokens.colorNeutral50,
        child: Padding(
          padding: EdgeInsets.all(Spacing.md.width),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: disponivel ? SimTokens.colorPrimary50 : SimTokens.colorNeutral50,
                  borderRadius: BorderRadius.circular(SimTokens.roundedMd),
                ),
                child: Icon(
                  cadastro.icone,
                  size: 22,
                  color: disponivel ? SimTokens.colorPrimary500 : SimTokens.colorNeutral400,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cadastro.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SimTypography.titleSmSemiBold.copyWith(
                        color: disponivel ? null : SimTokens.colorNeutral600,
                      ),
                    ),
                    Spacing.xxs.vertical,
                    Text(
                      cadastro.descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: SimTypography.bodySmRegular.copyWith(color: SimTokens.colorNeutral500),
                    ),
                    if (!disponivel) ...[
                      Spacing.xs.vertical,
                      const SimStatusChip(label: 'Em breve'),
                    ],
                  ],
                ),
              ),
              if (disponivel) ...[
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 20, color: SimTokens.colorNeutral400),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
