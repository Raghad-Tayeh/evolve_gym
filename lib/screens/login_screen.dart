import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart'; // Your new service
import 'package:evolve_gym/services/auth_gate.dart'; // The router we built

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Add controllers to read the text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // 2. Add a loading state to prevent double-clicks
  bool _isLoading = false;

  // 3. The actual login function
  Future<void> _handleLogin() async {
    // Basic validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both fields"), backgroundColor: Colors.orangeAccent),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Call your Supabase Service
    final success = await SupabaseService.loginUser(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    // Check if the widget is still on screen before navigating
    if (mounted) {
      setState(() => _isLoading = false);
      
      if (success) {
        // Successful Login! Let the AuthGate decide which dashboard they see.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      } else {
        // Failed Login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid email or password"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.fitness_center, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Login to your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController, // Attached controller
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController, // Attached controller
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 8),
            // Forgot Password Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to your Forgot Password screen here
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 56, // Fixed height so it doesn't shrink when loading
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isLoading ? null : _handleLogin, // Disable if loading
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black) // Show spinner
                    : const Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            // Optional: Sign Up Routing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?", style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {
                    // Navigate to Sign Up Screen
                  },
                  child: const Text("Sign Up", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}