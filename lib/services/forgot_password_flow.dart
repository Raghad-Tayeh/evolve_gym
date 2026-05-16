import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart';

class ForgotPasswordFlow extends StatefulWidget {
  const ForgotPasswordFlow({super.key});

  @override
  State<ForgotPasswordFlow> createState() => _ForgotPasswordFlowState();
}

class _ForgotPasswordFlowState extends State<ForgotPasswordFlow> {
  int _currentStep = 1; // 1: Email Request, 2: OTP Entry, 3: New Password New Credential
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // STEP 1 Execution: Send Reset Code
  Future<void> _sendCode() async {
    if (_emailController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    final success = await SupabaseService.sendPasswordResetEmail(_emailController.text.trim());
    
    setState(() => _isLoading = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("6-Digit reset code sent to your email!"), backgroundColor: Colors.green),
      );
      setState(() => _currentStep = 2); // Transition to OTP Verification Panel
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error sending recovery email. Verify the address."), backgroundColor: Colors.redAccent),
      );
    }
  }

  // STEP 2 Execution: Verify the Code 
  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length < 6) return;
    setState(() => _isLoading = true);

    final verified = await SupabaseService.verifyResetCode(
      _emailController.text.trim(),
      _otpController.text.trim(),
    );

    setState(() => _isLoading = false);
    if (verified) {
      setState(() => _currentStep = 3); // Validation cleared, move to final entry terminal
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid or expired authentication token. Try again."), backgroundColor: Colors.redAccent),
      );
    }
  }

  // STEP 3 Execution: Save New Password 
  Future<void> _submitNewPassword() async {
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 6 characters."), backgroundColor: Colors.orange),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match."), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);
    final saved = await SupabaseService.updatePassword(_passwordController.text.trim());
    setState(() => _isLoading = false);

    if (saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully! Please log in."), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Drop back onto the standard login root cleanly
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update password. Try the request again."), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: 400,
            child: _buildActiveStepView(),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveStepView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
    }

    switch (_currentStep) {
      case 2:
        return _stepEnterOtp();
      case 3:
        return _stepResetPassword();
      case 1:
      default:
        return _stepRequestEmail();
    }
  }

  // UI View Layout Block: Step 1
  Widget _stepRequestEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Reset Password", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        const Text("Enter your account's registered email address below to receive a secure recovery verification code.", style: TextStyle(color: Colors.grey, height: 1.4)),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Email Address",
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: _sendCode,
            child: const Text("Get Reset Code", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }

  // UI View Layout Block: Step 2
  Widget _stepEnterOtp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Verify Identity", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        Text("Type in the 6-digit recovery code sent to ${_emailController.text.trim()}.", style: const TextStyle(color: Colors.grey, height: 1.4)),
        const SizedBox(height: 24),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 4),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: "Verification Token Code",
            counterText: "",
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: _verifyOtp,
            child: const Text("Verify Token Code", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }

  // UI View Layout Block: Step 3
  Widget _stepResetPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("New Password", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        const Text("Authentication verified. Please type in and confirm your new permanent security password below.", style: TextStyle(color: Colors.grey, height: 1.4)),
        const SizedBox(height: 24),
        TextField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "New Password",
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Confirm Password",
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: _submitNewPassword,
            child: const Text("Update Password", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }
}