import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const EvolveGymApp());
}

class EvolveGymApp extends StatelessWidget {
  const EvolveGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.greenAccent,
      ),
      home: const LoginScreen(),
    );
  }
}

