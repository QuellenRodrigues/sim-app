import 'package:dependencies/dependencies.dart';

import '../mvvm.dart';

/// [ViewModelConsumer] exposes a [builder] and [listener] in order react to new
/// states.
/// [ViewModelConsumer] is analogous to a nested [ViewModelListener]
/// and [ViewModelBuilder] but reduces the amount of boilerplate needed.
/// [ViewModelConsumer] should only be used when it is necessary to both rebuild
/// UI and execute other reactions to state changes in the [ViewModel].
class ViewModelConsumer<VM extends ViewModel<S>, S extends ViewModelState> extends BlocConsumer<VM, S> {
  /// Creates a [ViewModelConsumer]
  const ViewModelConsumer({
    super.key,
    required VM viewModel,
    required super.builder,
    required super.listener,
    super.buildWhen,
    super.listenWhen,
  }) : super(bloc: viewModel);
}
