// ignore_for_file: deprecated_member_use

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppocket/components/navigation.dart';
import 'package:ppocket/services/auth_service.dart';
import 'package:ppocket/views/bottom_navigation/bottom_nav.dart';
import 'package:ppocket/views/budget_screens/budget_home_screen.dart';
import 'package:ppocket/views/stats_screens/stats_screen.dart';
import 'package:ppocket/views/scanqr.dart';
import 'package:ppocket/views/signup_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: DevicePreview.appBuilder,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: 'PPocket',
      theme: ThemeData(
        //theme data should be in theme folder
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FirebaseAuthService.currentUser == null
          ? const SignUpPage()
          : const BottomNav(),
      // home: const BudgetHome(),
      // home: const StatScreen(),
      // home: const BottomNav(),

      // home: const ScanQr(),
    );
  }
}
