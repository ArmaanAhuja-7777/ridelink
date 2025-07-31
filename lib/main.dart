import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ridelink/pages/home_page.dart';
import 'package:ridelink/pages/main_page.dart';
import 'package:ridelink/pages/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
