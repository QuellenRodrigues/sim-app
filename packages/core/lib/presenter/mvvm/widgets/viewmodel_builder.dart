import 'package:dependencies/dependencies.dart';
import 'package:flutter/widgets.dart';

import '../mvvm.dart';

/// Signature for the `builder` function which takes the `BuildContext` and
/// [ViewModelState] and is responsible for returning a widget which is  to be
/// rendered. This is analogous to the `builder` function in [StreamBuilder].
typedef ViewModelWidgetBuilder<S> = Widget Function(BuildContext context, S state);

/// Signature for the `buildWhen` function which takes the previous `state` and
/// the current `state` and is responsible for returning a [bool] which
/// determines whether to rebuild [ViewModelBuilder] with the current `state`.
typedef ViewModelBuilderCondition<S> = bool Function(S previous, S current);

/// [ViewModelBuilder] handles building a widget in response to new `states`
class ViewModelBuilder<VM extends ViewModel<S>, S extends ViewModelState> extends BlocBuilder<VM, S> {
  /// Creates a [ViewModelBuilder]
  const ViewModelBuilder({
    super.key,
    required VM viewModel,
    required super.builder,
    super.buildWhen,
  }) : super(bloc: viewModel);
}
