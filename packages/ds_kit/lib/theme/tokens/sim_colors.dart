import 'package:flutter/material.dart';

/// Paleta nomeada do SIM. Nas telas, prefira os tokens semânticos de [SimTokens].
abstract final class SimColors {
  SimColors._();

  /// #FFFFFF
  static const Color white = Color(0xFFFFFFFF);

  /// #000000
  static const Color black = Color(0xFF000000);

  /// #00000000
  static const Color transparent = Color(0x00000000);

  /// #2E2840 — fundos de destaque
  static const Color purpuraNoite = Color(0xFF2E2840);

  /// #463873
  static const Color purpuraProfunda = Color(0xFF463873);

  /// #5A4790 — cor primária da marca (faixa curta do símbolo)
  static const Color purpuraSim = Color(0xFF5A4790);

  /// #8B7BBF
  static const Color lavanda = Color(0xFF8B7BBF);

  /// #E7E1F6
  static const Color nevoaLavanda = Color(0xFFE7E1F6);

  /// #F3F0FA
  static const Color brumaLavanda = Color(0xFFF3F0FA);

  /// #237A39
  static const Color verdeMata = Color(0xFF237A39);

  /// #2E9E4A — verde "aprovado" (faixa longa do símbolo)
  static const Color verdeAprovado = Color(0xFF2E9E4A);

  /// #7FD68F — verde do símbolo sobre fundos escuros
  static const Color verdeClaro = Color(0xFF7FD68F);

  /// #DDF3E2
  static const Color menta = Color(0xFFDDF3E2);

  /// #1A1A1F
  static const Color grafiteProfundo = Color(0xFF1A1A1F);

  /// #2B2D33 — wordmark "sim"
  static const Color grafite = Color(0xFF2B2D33);

  /// #3B3B45
  static const Color aco700 = Color(0xFF3B3B45);

  /// #52525E
  static const Color aco600 = Color(0xFF52525E);

  /// #6E6E7C
  static const Color aco500 = Color(0xFF6E6E7C);

  /// #9696A3
  static const Color aco400 = Color(0xFF9696A3);

  /// #C3C3CC
  static const Color aco300 = Color(0xFFC3C3CC);

  /// #DDDDE3
  static const Color aco200 = Color(0xFFDDDDE3);

  /// #EEEEF2
  static const Color aco100 = Color(0xFFEEEEF2);

  /// #F7F7F9
  static const Color aco50 = Color(0xFFF7F7F9);

  /// #A87405
  static const Color ambarEscuro = Color(0xFFA87405);

  /// #D99A0B
  static const Color ambar = Color(0xFFD99A0B);

  /// #FBEFCF
  static const Color creme = Color(0xFFFBEFCF);

  /// #A3302A
  static const Color vermelhoEscuro = Color(0xFFA3302A);

  /// #CC3D36
  static const Color vermelho = Color(0xFFCC3D36);

  /// #FADCDA
  static const Color rosado = Color(0xFFFADCDA);

  /// #2A5F9C
  static const Color azulEscuro = Color(0xFF2A5F9C);

  /// #3577C2
  static const Color azul = Color(0xFF3577C2);

  /// #DCE9F8
  static const Color celeste = Color(0xFFDCE9F8);
}
