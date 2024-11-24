import 'package:flutter/material.dart';
import 'package:quick_vid/consts/strings.dart';
import 'package:quick_vid/screens/home_screen.dart';
import 'package:quick_vid/screens/video_details.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case videoDetails:
        String videoId = args['VideoUrl'] as String;
        return MaterialPageRoute(
          builder: (_) => VideoDetails(
            videoUrl: videoId,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
