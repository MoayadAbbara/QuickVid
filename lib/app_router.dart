import 'package:flutter/material.dart';
import 'package:quick_vid/consts/strings.dart';
import 'package:quick_vid/screens/chat_screen.dart';
import 'package:quick_vid/screens/full_transkript_screen.dart';
import 'package:quick_vid/screens/home_screen.dart';
import 'package:quick_vid/screens/summarized_transkript_screen.dart';
import 'package:quick_vid/screens/video_details.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case videoDetails:
        String videoUrl = args['VideoUrl'] as String;
        return MaterialPageRoute(
          builder: (_) => VideoDetails(
            videoUrl: videoUrl,
          ),
        );
      case videoFullTranskript:
        String videoId = args['VideoId'] as String;
        return MaterialPageRoute(
          builder: (_) => FullTranskript(
            videoId: videoId,
          ),
        );
      case videoSummarizedTranskript:
        String videoId = args['VideoId'] as String;
        return MaterialPageRoute(
          builder: (_) => SummarizedTranskript(
            videoId: videoId,
          ),
        );
      case chat:
        String videoId = args['VideoId'] as String;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            videoId: videoId,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
