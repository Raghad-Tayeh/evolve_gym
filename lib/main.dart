import 'package:evolve_gym/appcolors.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const EvolveGymApp());
}

class EvolveGymApp extends StatelessWidget {
  const EvolveGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bg,
        primaryColor: Colors.greenAccent,
      ),
      home: const LoginScreen(),
    );
  }
}
