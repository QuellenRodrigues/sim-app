import 'package:core/core.dart';

class MenuState extends ViewModelState {
  factory MenuState.initial() => const MenuState();

  const MenuState({this.currentIndex = 0});

  final int currentIndex;

  MenuState copyWith({int? currentIndex}) {
    return MenuState(currentIndex: currentIndex ?? this.currentIndex);
  }
}
