import 'package:flutter/material.dart';

import 'package:food_track/feature/Auth/home_provider.dart';
import 'package:food_track/feature/splash/splash_view.dart';
import 'package:food_track/product/initialize/application_start.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await ApplicationStart.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashView(
          goToMainScreen: false,
          showOnboardingPages: true,
        ),
      ),
    );
  }
}
