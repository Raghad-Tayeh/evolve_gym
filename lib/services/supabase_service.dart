import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // 1. Initialize the shared client
  static final SupabaseClient client = Supabase.instance.client;

  // 2. Setup Function (Call this in main.dart)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://fvwqdmxdxdyifzodwmtv.supabase.co/rest/v1/', // Replace with your URL
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2d3FkbXhkeGR5aWZ6b2R3bXR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4Mjk0ODMsImV4cCI6MjA5NDQwNTQ4M30.F9Fnk1J-u55tj5Vzw0x95g4jhNDqsKgap610Dzr2ey4', // Replace with your Anon Key
    );
  }

  // --- AUTHENTICATION METHODS ---

  // Sign Up a new user and create their Profile
  static Future<bool> signUpUser(String email, String password, String fullName) async {
    try {
      final AuthResponse res = await client.auth.signUp(
        email: email,
        password: password,
      );

      final User? user = res.user;

      if (user != null) {
        // Create their row in the profiles table
        await client.from('profiles').insert({
          'id': user.id,
          'full_name': fullName,
          'role': 'member',
          'subscription_plan': 'Basic',
          'subscription_status': 'Active',
        });
        return true; // Success
      }
      return false;
    } catch (e) {
      print("Sign up error: $e");
      return false; // Failure
    }
  }

  // Log in an existing user
  static Future<bool> loginUser(String email, String password) async {
    try {
      await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return true; // Success
    } catch (e) {
      print("Login error: $e");
      return false; // Failure
    }
  }

  // Log the user out
  static Future<void> logoutUser() async {
    await client.auth.signOut();
  }

  // --- PASSWORD RESET FLOW ---

  // Step 1: Send the 6-digit OTP to the user's email
  static Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      print("Reset email error: $e");
      return false;
    }
  }

  // Step 2: Verify the 6-digit OTP
  static Future<bool> verifyResetCode(String email, String code) async {
    try {
      final AuthResponse res = await client.auth.verifyOTP(
        type: OtpType.recovery,
        token: code,
        email: email,
      );
      return res.session != null; // Returns true if verification succeeded
    } catch (e) {
      print("OTP verification error: $e");
      return false;
    }
  }

  // Step 3: Update to the new password (User must be verified from Step 2)
  static Future<bool> updatePassword(String newPassword) async {
    try {
      final UserAttributes attributes = UserAttributes(password: newPassword);
      await client.auth.updateUser(attributes);
      return true;
    } catch (e) {
      print("Password update error: $e");
      return false;
    }
  }

  // --- CLASS MANAGEMENT ---

  // 1. Fetch classes in real-time
  static Stream<List<Map<String, dynamic>>> getClassesStream() {
    // This listens to the database and orders them by upcoming times
    return client
        .from('classes')
        .stream(primaryKey: ['id'])
        .order('start_time', ascending: true);
  }

  // 2. Add a new class (For Coaches/Admins)
  static Future<bool> createClass({
    required String title,
    required String tag,
    required String level,
    required DateTime startTime,
    required int durationMins,
  }) async {
    try {
      final endTime = startTime.add(Duration(minutes: durationMins));
      
      await client.from('classes').insert({
        'title': title,
        'category': tag,
        'difficulty_level': level,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'capacity': 15, // Default capacity
        'instructor_id': client.auth.currentUser!.id, // Links to the logged-in coach
      });
      return true;
    } catch (e) {
      print("Create class error: $e");
      return false;
    }
  }

  // 3. Delete a class (For Coaches)
  static Future<bool> deleteClass(String classId) async {
    try {
      await client.from('classes').delete().eq('id', classId);
      return true;
    } catch (e) {
      print("Delete class error: $e");
      return false;
    }
  }

  // --- BOOKINGS ---

  // 4. Book a class (For Members)
  static Future<String?> bookClass(String classId) async {
    try {
      await client.from('bookings').insert({
        'user_id': client.auth.currentUser!.id,
        'class_id': classId,
      });
      return null; // Return null if successful
    } catch (e) {
      // If our SQL trigger blocks it (e.g., overlapping times), return the error string
      return "Booking failed. You may already be booked during this time.";
    }
  }
}