import 'package:flutter/material.dart';
import 'package:ridelink/pages/auth/signup_page.dart';
import 'package:ridelink/pages/profile_page.dart';
import 'package:ridelink/widgets/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const Color primaryColor = Color(0xFF6740BA);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ridelink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1B1F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
