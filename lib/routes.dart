import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class Routes {
  static const home = '/';
}

final Map<String, WidgetBuilder> routes = {
  Routes.home: (ctx) => const HomeScreen(),
};
