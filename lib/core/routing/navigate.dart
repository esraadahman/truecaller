import 'package:flutter/material.dart';

extension NavigationRouter on BuildContext {
  // used to navigate to another screen  (non named navigate)
  void navigateTo(Widget screen) {
    Navigator.of(this).push(MaterialPageRoute(builder: (context) => screen));
  }

  // pushReplacement → replace current screen (back exits app if no previous route).
  void navigateToEasy(Widget screen) {
    Navigator.of(
      this,
    ).pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  // used to back
  void goBack() {
    Navigator.of(this).pop();
  }

  // pushAndRemoveUntil → clear stack (good for Home after login).
  void navigateToAndClearStack(Widget screen) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
      (route) => false, // removes all previous routes
    );
  }

  // used to navigate to another screen  (named navigate)

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }
}
