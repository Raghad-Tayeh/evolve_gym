import 'package:evolve_gym/appcolors.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/supabase_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  Stripe.publishableKey = 'pk_test_51TY5KHAYGpIxTvIqRONXfI8M8K7BOm9Fv7N2OqLcAdDozrEaxfJJRnJf4lXpmahAXYbs3Nx0Gmm4X1ek24aEnrOO00vTHzL3IG';
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
