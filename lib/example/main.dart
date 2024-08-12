import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/example/vm.dart';
import 'package:state_management/export.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: FirstScreen()),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM(
        view: () => Builder(builder: (context) {
              return const FirstScreenView();
            }),
        viewModel: locator<FirstScreenVm>());
  }
}

class FirstScreenView extends StatelessView<FirstScreenVm> {
  const FirstScreenView({super.key});

  @override
  Widget render(BuildContext context, FirstScreenVm vm) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                vm.increment();
              },
              child: const Text('Increment'),
            ),
            Text(vm.counter.toString()),
            ElevatedButton(
              onPressed: () {
                vm.decrement();
              },
              child: const Text('decrement'),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SecondScreen()));
          },
          child: const Text('Next'),
        ),
        Spacer(),
      ],
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MVVM(
        view: () => Builder(builder: (context) {
              return const SecondScreenView();
            }),
        viewModel: SecondScreenVm());
  }
}

class DummyTwo extends StatelessView<SecondScreenVm> {
  const DummyTwo({super.key});

  @override
  Widget render(BuildContext context, SecondScreenVm vm) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('back'),
          ),
        ],
      ),
    );
  }
}

class DummayView extends StatelessView<SecondScreenVm> {
  const DummayView({super.key});

  @override
  Widget render(BuildContext context, SecondScreenVm vm) {
    return ChangeNotifierProvider.value(
      value: locator<FirstScreenVm>(),
      child: Consumer<FirstScreenVm>(
        builder: (context, sharedVm, child) {
          return Scaffold(
              body: Column(
            children: [
              Text("Shared vm"),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      sharedVm.increment();
                    },
                    child: const Text('Increment'),
                  ),
                  Text(sharedVm.counter.toString()),
                  ElevatedButton(
                    onPressed: () {
                      sharedVm.decrement();
                    },
                    child: const Text('decrement'),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('back'),
              ),
              Spacer(),
              Text("Current vm"),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      vm.increment();
                    },
                    child: const Text('Increment'),
                  ),
                  Text(vm.counter.toString()),
                  ElevatedButton(
                    onPressed: () {
                      vm.decrement();
                    },
                    child: const Text('decrement'),
                  ),
                ],
              ),
            ],
          ));
        },
      ),
    );
  }
}

class SecondScreeViewTwo extends StatelessView<SecondScreenVm> {
  const SecondScreeViewTwo({super.key});

  @override
  Widget render(BuildContext context, SecondScreenVm vm) {
    return SharedVM<FirstScreenVm>(
        reactive: true,
        builder: (context, sharedVm) {
          return Scaffold(
              body: Column(
            children: [
              Text("Shared vm"),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      sharedVm.increment();
                    },
                    child: const Text('Increment'),
                  ),
                  Text(sharedVm.counter.toString()),
                  ElevatedButton(
                    onPressed: () {
                      sharedVm.decrement();
                    },
                    child: const Text('decrement'),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('back'),
              ),
              Spacer(),
              Text("Current vm"),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      vm.increment();
                    },
                    child: const Text('Increment'),
                  ),
                  Text(vm.counter.toString()),
                  ElevatedButton(
                    onPressed: () {
                      vm.decrement();
                    },
                    child: const Text('decrement'),
                  ),
                ],
              ),
            ],
          ));
        });
  }
}

class SecondScreenView
    extends StatelessViewWithSharedVmCurrentVM<FirstScreenVm, SecondScreenVm> {
  const SecondScreenView({super.key, super.reactiveShared = false});

  @override
  Widget render(
      BuildContext context, FirstScreenVm sharedVm, SecondScreenVm vm) {
    return Scaffold(
        body: Column(
      children: [
        Text("Shared vm"),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                sharedVm.increment();
              },
              child: const Text('Increment'),
            ),
            Text(sharedVm.counter.toString()),
            ElevatedButton(
              onPressed: () {
                sharedVm.decrement();
              },
              child: const Text('decrement'),
            ),
          ],
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('back'),
        ),
        Spacer(),
        Text("Current vm"),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                vm.increment();
              },
              child: const Text('Increment'),
            ),
            Text(vm.counter.toString()),
            ElevatedButton(
              onPressed: () {
                vm.decrement();
              },
              child: const Text('decrement'),
            ),
          ],
        ),
      ],
    ));
  }

  @override
  FirstScreenVm provideSharedViewModel() {
    return locator<FirstScreenVm>();
  }
}

class ThirdScreen extends StatelessViewWithSharedVm<FirstScreenVm> {
  const ThirdScreen({super.key});

  @override
  Widget render(BuildContext context, FirstScreenVm sharedVm) {
    return Scaffold(
        body: Column(
      children: [
        Text("Shared vm"),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                sharedVm.increment();
              },
              child: const Text('Increment'),
            ),
            Text(sharedVm.counter.toString()),
            ElevatedButton(
              onPressed: () {
                sharedVm.decrement();
              },
              child: const Text('decrement'),
            ),
          ],
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('back'),
        ),
        Spacer(),
      ],
    ));
  }

  @override
  FirstScreenVm provideSharedViewModel() {
    return locator<FirstScreenVm>();
  }
}

void setupLocator() {
  locator.registerFactory<FirstScreenVm>(() => FirstScreenVm());
  locator.registerFactory<SecondScreenVm>(() => SecondScreenVm());
}
