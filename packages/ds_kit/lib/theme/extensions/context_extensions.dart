import 'package:flutter/material.dart';

extension ContextThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get color => theme.colorScheme;

  TextTheme get text => theme.textTheme;

  bool get isInModalRoute => ModalRoute.of(this)?.isCurrent == false;

  void closeKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.unfocus();
    }
  }
}
