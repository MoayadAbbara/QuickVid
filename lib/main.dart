import 'package:flutter/material.dart';
import 'package:quick_vid/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
