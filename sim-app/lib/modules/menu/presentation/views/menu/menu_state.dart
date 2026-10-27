import 'package:core/core.dart';

class MenuState extends ViewModelState {
  factory MenuState.initial() => const MenuState();

  const MenuState({
    this.currentIndex = 0,
    this.usuarioNome = 'Administrador',
    this.usuarioPerfil = 'Planejamento',
  });

  final int currentIndex;

  // TODO: vir da sessão quando o login existir.
  final String usuarioNome;
  final String usuarioPerfil;

  MenuState copyWith({int? currentIndex}) {
    return MenuState(
      currentIndex: currentIndex ?? this.currentIndex,
      usuarioNome: usuarioNome,
      usuarioPerfil: usuarioPerfil,
    );
  }
}
