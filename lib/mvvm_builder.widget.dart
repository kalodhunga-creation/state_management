import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:state_management/utils/index.dart';
import 'package:state_management/view_model.dart';

/// The MVVM builder widget.
class MVVM<T extends ViewModel> extends StatefulWidget {
  final MVVMBaseProps<T> props;

  MVVM({
    Key? key,
    required Widget Function() view,
    required T viewModel,
    bool disposeVM = true,
  })  : props = MVVMProps(
          view: view,
          viewModel: viewModel,
          disposeVM: disposeVM,
        ),
        super(key: key);

  MVVM.builder({
    Key? key,
    required Widget Function(BuildContext context, T vm) viewBuilder,
    required T viewModel,
    bool disposeVM = true,
  })  : props = MVVMBuilderProps(
          viewBuilder: viewBuilder,
          viewModel: viewModel,
          disposeVM: disposeVM,
        ),
        super(key: key);

  @override
  _MVVMState<T> createState() => _MVVMState<T>();
}

class _MVVMState<T extends ViewModel> extends State<MVVM<T>>
    with WidgetsBindingObserver, DidInitStateMixin<MVVM<T>> {
  late T _vm;

  @override
  void initState() {
    super.initState();
    _vm = widget.props.viewModel;
    _vm.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _vm.onMount());
  }

  @override
  void didInitState() {
    _vm.context = context;
    _vm.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _vm.onResume();
    } else if (state == AppLifecycleState.inactive) {
      _vm.onInactive();
    } else if (state == AppLifecycleState.paused) {
      _vm.onPause();
    } else if (state == AppLifecycleState.detached) {
      _vm.onDetach();
    }
  }

  @override
  void didChangeDependencies() {
    _vm.onDependenciesChange();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _vm.onUnmount();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _vm.onBuild();

    if (widget.props is MVVMProps) {
      final props = widget.props as MVVMProps<T>;

      if (!widget.props.disposeVM) {
        return ChangeNotifierProvider<T>.value(value: _vm, child: props.view());
      }

      return ChangeNotifierProvider<T>(create: (_) => _vm, child: props.view());
    }

    final props = widget.props as MVVMBuilderProps<T>;

    if (!widget.props.disposeVM) {
      return ChangeNotifierProvider<T>.value(
        value: _vm,
        child: Consumer<T>(
          builder: (context, vm, _) => props.viewBuilder(context, vm),
        ),
      );
    }

    return ChangeNotifierProvider<T>(
      create: (_) => _vm,
      child: Consumer<T>(
        builder: (context, vm, _) => props.viewBuilder(context, vm),
      ),
    );
  }
}

class MVVMBaseProps<T extends ViewModel> {
  /// The view model of the view.
  final T viewModel;

  /// To dispose the [viewModel] when the provider is removed from the
  /// widget tree.
  final bool disposeVM;

  MVVMBaseProps({
    required this.viewModel,
    required this.disposeVM,
  });
}

class MVVMProps<T extends ViewModel> extends MVVMBaseProps<T> {
  /// A builder function for the View widget.
  final Widget Function() view;

  MVVMProps({
    required this.view,
    required T viewModel,
    required bool disposeVM,
  }) : super(viewModel: viewModel, disposeVM: disposeVM);
}

class MVVMBuilderProps<T extends ViewModel> extends MVVMBaseProps<T> {
  /// A builder function for the View widget, it also has access
  /// to the [viewModel].
  final Widget Function(BuildContext, T) viewBuilder;

  MVVMBuilderProps({
    required this.viewBuilder,
    required T viewModel,
    required bool disposeVM,
  }) : super(viewModel: viewModel, disposeVM: disposeVM);
}
