import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:state_management/view_model.dart';

GetIt locator = GetIt.instance;

/// The view of the MVVM architecture.
abstract class StatelessView<T extends ViewModel> extends StatelessWidget {
  const StatelessView({Key? key, this.reactive = true}) : super(key: key);

  final bool reactive;

  @override
  Widget build(BuildContext context) =>
      render(context, Provider.of<T>(context, listen: reactive));

  Widget render(BuildContext context, T vm);
}

/// A wrapper for screens that require a `ChangeNotifierProvider` with a `Consumer`.
abstract class StatelessViewWithSharedVm<S extends ViewModel>
    extends StatelessWidget {
  const StatelessViewWithSharedVm({Key? key, this.reactive = false})
      : super(key: key);

  final bool reactive;

  /// Provides the ViewModel instance.

  @override
  Widget build(BuildContext context) {
    if (reactive) {
      return ChangeNotifierProvider.value(
        value: locator<S>(),
        child: Consumer<S>(
          builder: (context, vm, child) {
            return render(context, vm);
          },
        ),
      );
    } else {
      return render(context, locator<S>());
    }
  }

  /// Method to render the UI, to be implemented by subclasses.
  Widget render(BuildContext context, S vm);
}

abstract class StatelessViewWithSharedVmCurrentVM<S extends ViewModel,
    T extends ViewModel> extends StatelessWidget {
  const StatelessViewWithSharedVmCurrentVM(
      {Key? key, this.reactiveShared = false, this.reactiveCurrent = true})
      : super(key: key);

  final bool reactiveShared;
  final bool reactiveCurrent;

  /// Provides the shared ViewModel instance.

  @override
  Widget build(BuildContext context) {
    if (reactiveShared) {
      return ChangeNotifierProvider.value(
        value: locator<S>(),
        child: Consumer<S>(
          builder: (context, sharedVm, child) {
            return render(context, sharedVm,
                Provider.of<T>(context, listen: reactiveCurrent));
          },
        ),
      );
    }
    return render(context, locator<S>(),
        Provider.of<T>(context, listen: reactiveCurrent));
  }

  Widget render(BuildContext context, S sharedVm, T currentVm);
}
