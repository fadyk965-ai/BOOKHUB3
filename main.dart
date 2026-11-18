import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/app/appdart/app.dart';
import 'core/config/app_mode.dart';
import 'core/config/demo_firebase_options.dart';
import 'core/di/service_locator.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {
    // الوضع التجريبي لا يحتوي أي حسابات أو بيانات حقيقية؛ كل البيانات تبقى محلية.
    AppMode.isDemo = true;
    await Firebase.initializeApp(options: DemoFirebaseOptions.currentPlatform);
  }
  await configureDependencies();
  runApp(const BookHubApp());
}
