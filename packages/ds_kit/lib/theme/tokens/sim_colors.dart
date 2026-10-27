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

  /// #5A4790 — cor primária da marca
  static const Color purpuraSim = Color(0xFF5A4790);

  /// #8B7BBF
  static const Color lavanda = Color(0xFF8B7BBF);

  /// #E7E1F6
  static const Color nevoaLavanda = Color(0xFFE7E1F6);

  /// #F3F0FA
  static const Color brumaLavanda = Color(0xFFF3F0FA);

  /// #237A39
  static const Color verdeMata = Color(0xFF237A39);

  /// #2E9E4A — verde "aprovado" (check do símbolo)
  static const Color verdeAprovado = Color(0xFF2E9E4A);

  /// #7FD68F — verde do símbolo sobre fundos escuros
  static const Color verdeClaro = Color(0xFF7FD68F);

  /// #DDF3E2
  static const Color menta = Color(0xFFDDF3E2);

  /// #1A1A1F
  static const Color grafiteProfundo = Color(0xFF1A1A1F);

  /// #2B2D33 — wordmark "SIM" e caixa do símbolo
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

  /// #8A5F04
  static const Color ambarEscuro = Color(0xFF8A5F04);

  /// #F2BE4A — âmbar sobre fundos escuros
  static const Color ambarClaro = Color(0xFFF2BE4A);

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

  /// #F0B8B4
  static const Color rosadoBorda = Color(0xFFF0B8B4);

  /// #FDF1F0
  static const Color rosadoNevoa = Color(0xFFFDF1F0);

  /// #2A5F9C
  static const Color azulEscuro = Color(0xFF2A5F9C);

  /// #3577C2
  static const Color azul = Color(0xFF3577C2);

  /// #DCE9F8
  static const Color celeste = Color(0xFFDCE9F8);

  /// #F4F4F7 — fundo das telas
  static const Color gelo = Color(0xFFF4F4F7);

  /// #E4E4EA — bordas de cartões
  static const Color geloBorda = Color(0xFFE4E4EA);

  // Menu lateral (fundo escuro)

  /// #1C1D22
  static const Color noite = Color(0xFF1C1D22);

  /// #26272E
  static const Color noiteSuperficie = Color(0xFF26272E);

  /// #2D2E36
  static const Color noiteBorda = Color(0xFF2D2E36);

  /// #C9C9D3
  static const Color noiteTexto = Color(0xFFC9C9D3);

  /// #A5A5B2
  static const Color noiteTextoSuave = Color(0xFFA5A5B2);

  /// #8E8E9C
  static const Color noiteRotulo = Color(0xFF8E8E9C);

  // Faixa de destaque (púrpura escuro)

  /// #3A3256
  static const Color purpuraNoiteMedia = Color(0xFF3A3256);

  /// #463B6A
  static const Color purpuraNoiteFaixa = Color(0xFF463B6A);

  /// #54487E
  static const Color purpuraNoiteClara = Color(0xFF54487E);

  /// #C9BEF0
  static const Color lavandaClara = Color(0xFFC9BEF0);

  /// #E2DCF3
  static const Color lavandaTexto = Color(0xFFE2DCF3);
}
