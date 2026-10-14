import 'package:dependencies/dependencies.dart';
import 'package:flutter/widgets.dart';

import '../mvvm.dart';

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `state` and is responsible for executing in response to
/// `state` changes.
typedef ViewModelWidgetListener<S> =
    void Function(
      BuildContext context,
      S state,
    );

/// Signature for the `listenWhen` function which takes the previous `state`
/// and the current `state` and is responsible for returning a [bool] which
/// determines whether or not to call [ViewModelListener] with the current
/// `state`.
typedef ViewModelListenerCondition<S> = bool Function(S previous, S current);

/// Takes a [ViewModelListener] and a required [ViewModel] and invokes
/// the [listener] in response to `state` changes in the [ViewModel].
/// It should be used for functionality that needs to occur only in response to
/// a `state` change such as navigation, showing a `SnackBar`, showing
/// a `Dialog`, etc...
class ViewModelListener<VM extends ViewModel<S>, S extends ViewModelState> extends BlocListener<VM, S> {
  /// Creates a [ViewModelListener]
  const ViewModelListener({
    super.key,
    required VM viewModel,
    required super.listener,
    super.listenWhen,
    super.child,
  }) : super(bloc: viewModel);
}
