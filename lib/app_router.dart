import 'package:flutter/material.dart';
import 'package:quick_vid/consts/strings.dart';
import 'package:quick_vid/screens/home_screen.dart';
import 'package:quick_vid/screens/test_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homepage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case test:
        return MaterialPageRoute(builder: (_) => const MyWidget());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
