import 'package:firebase_core/firebase_core.dart';
import 'package:food_track/firebase_options.dart';
import 'package:kartal/kartal.dart';
import 'package:flutter/material.dart';

@immutable
class ApplicationStart {
  const ApplicationStart._();
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DeviceUtility.deviceInit();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
