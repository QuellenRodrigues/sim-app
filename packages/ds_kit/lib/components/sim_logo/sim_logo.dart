import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Logotipo do SIM: wordmark "sim" + símbolo de check em duas faixas.
///
/// ```dart
/// const SimLogo(height: 32)                  // horizontal
/// const SimLogo.simbolo(height: 32)          // só o símbolo
/// const SimLogo(height: 32, negativo: true)  // sobre fundo escuro
/// ```
class SimLogo extends StatelessWidget {
  const SimLogo({
    super.key,
    this.height = 32,
    this.negativo = false,
    this.mostrarAssinatura = false,
  }) : _somenteSimbolo = false;

  const SimLogo.simbolo({
    super.key,
    this.height = 32,
    this.negativo = false,
  }) : _somenteSimbolo = true,
       mostrarAssinatura = false;

  /// Altura do wordmark (o símbolo acompanha).
  final double height;

  /// Versão para fundos escuros/púrpura.
  final bool negativo;

  /// Exibe "sistema integrado da mecânica" abaixo do logo.
  final bool mostrarAssinatura;

  final bool _somenteSimbolo;

  @override
  Widget build(BuildContext context) {
    final simbolo = SvgPicture.asset(
      negativo ? AppAssets.logoSimboloNegativoSvg : AppAssets.logoSimboloSvg,
      package: AppAssets.package,
      width: _somenteSimbolo ? height * 0.8 : height,
      height: _somenteSimbolo ? height * 0.8 : height,
    );

    if (_somenteSimbolo) {
      return Semantics(
        label: 'SIM',
        child: SizedBox.square(
          dimension: height,
          child: Center(child: simbolo),
        ),
      );
    }

    final cor = negativo ? SimTokens.colorWhite : SimTokens.colorNeutral800;
    final logo = Semantics(
      label: 'SIM — Sistema Integrado da Mecânica',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ExcludeSemantics(child: Text('sim', style: SimTypography.wordmark(height * 1.12, cor))),
          SizedBox(width: height * 0.1),
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.04),
            child: simbolo,
          ),
        ],
      ),
    );

    if (!mostrarAssinatura) return logo;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        logo,
        SizedBox(height: height * 0.18),
        Text(
          'sistema integrado da mecânica',
          style: SimTypography.wordmark(height * 0.26, cor.withValues(alpha: 0.8)).copyWith(
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
