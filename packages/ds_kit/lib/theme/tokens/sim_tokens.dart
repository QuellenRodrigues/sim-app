import 'sim_colors.dart';

class SimTokens {
  SimTokens._();

  /// Largura de referência do layout (web desktop).
  static const int designScreenWidth = 1440;

  /// Altura de referência do layout (web desktop).
  static const int designScreenHeight = 900;

  // Primary
  static const colorPrimary900 = SimColors.purpuraNoite;
  static const colorPrimary700 = SimColors.purpuraProfunda;
  static const colorPrimary500 = SimColors.purpuraSim;
  static const colorPrimary300 = SimColors.lavanda;
  static const colorPrimary100 = SimColors.nevoaLavanda;
  static const colorPrimary50 = SimColors.brumaLavanda;

  // Neutral
  static const colorWhite = SimColors.white;
  static const colorNeutral900 = SimColors.grafiteProfundo;
  static const colorNeutral800 = SimColors.grafite;
  static const colorNeutral700 = SimColors.aco700;
  static const colorNeutral600 = SimColors.aco600;
  static const colorNeutral500 = SimColors.aco500;
  static const colorNeutral400 = SimColors.aco400;
  static const colorNeutral300 = SimColors.aco300;
  static const colorNeutral200 = SimColors.aco200;
  static const colorNeutral100 = SimColors.aco100;
  static const colorNeutral50 = SimColors.aco50;
  static const transparent = SimColors.transparent;
  static const colorBackground = SimColors.gelo;
  static const colorBorder = SimColors.geloBorda;

  // Sidebar (menu lateral escuro)
  static const colorSidebar = SimColors.noite;
  static const colorSidebarSurface = SimColors.noiteSuperficie;
  static const colorSidebarBorder = SimColors.noiteBorda;
  static const colorSidebarText = SimColors.noiteTexto;
  static const colorSidebarTextMuted = SimColors.noiteTextoSuave;
  static const colorSidebarLabel = SimColors.noiteRotulo;

  // Highlight (faixa de destaque em púrpura escuro)
  static const colorHighlight = SimColors.purpuraNoite;
  static const colorHighlightSurface = SimColors.purpuraNoiteMedia;
  static const colorHighlightStripe = SimColors.purpuraNoiteFaixa;
  static const colorHighlightBorder = SimColors.purpuraNoiteClara;
  static const colorHighlightText = SimColors.lavandaTexto;
  static const colorHighlightMuted = SimColors.lavandaClara;
  static const colorHighlightSuccess = SimColors.verdeClaro;
  static const colorHighlightWarning = SimColors.ambarClaro;

  // Success
  static const colorSuccess700 = SimColors.verdeMata;
  static const colorSuccess500 = SimColors.verdeAprovado;
  static const colorSuccess100 = SimColors.menta;

  // Warning
  static const colorWarning700 = SimColors.ambarEscuro;
  static const colorWarning500 = SimColors.ambar;
  static const colorWarning100 = SimColors.creme;

  // Error
  static const colorError700 = SimColors.vermelhoEscuro;
  static const colorError500 = SimColors.vermelho;
  static const colorError100 = SimColors.rosado;
  static const colorErrorBorder = SimColors.rosadoBorda;
  static const colorError50 = SimColors.rosadoNevoa;

  // Info
  static const colorInfo700 = SimColors.azulEscuro;
  static const colorInfo500 = SimColors.azul;
  static const colorInfo100 = SimColors.celeste;

  // Borders
  static const double borderNone = 0;
  static const double borderSm = 1;
  static const double borderMd = 2;

  // Radius
  static const double rounded2xs = 4;
  static const double roundedXs = 6;
  static const double roundedSm = 8;
  static const double roundedMd = 12;
  static const double roundedLg = 16;
  static const double roundedXl = 24;
  static const double roundedMax = 250;
}
