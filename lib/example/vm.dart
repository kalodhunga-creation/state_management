import 'package:state_management/export.dart';

class FirstScreenVm extends ViewModel {
  int? counter = 0;

  void increment() {
    counter = counter! + 1;
    notifyListeners();
  }

  void decrement() {
    counter = counter! - 1;
    notifyListeners();
  }
}

class SecondScreenVm extends ViewModel {
  int? counter = 100;

  void increment() {
    counter = counter! + 1;
    notifyListeners();
  }

  void decrement() {
    counter = counter! - 1;
    notifyListeners();
  }
}
