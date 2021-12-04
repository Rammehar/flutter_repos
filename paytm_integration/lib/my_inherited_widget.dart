import 'package:flutter/material.dart';
import 'package:paytm_integration/my_notifier.dart';

class MyInheritedWidget extends InheritedWidget {
  final UserModel userModel;
  final Widget child;

  MyInheritedWidget({Key key, this.userModel, this.child})
      : super(child: child);

  static MyInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(MyInheritedWidget old) => true;
}
