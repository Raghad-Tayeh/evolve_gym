import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // 1. Initialize the shared client
  static final SupabaseClient client = Supabase.instance.client;

  // 2. Setup Function (Call this in main.dart)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://fvwqdmxdxdyifzodwmtv.supabase.co', // Replace with your URL
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ2d3FkbXhkeGR5aWZ6b2R3bXR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg4Mjk0ODMsImV4cCI6MjA5NDQwNTQ4M30.F9Fnk1J-u55tj5Vzw0x95g4jhNDqsKgap610Dzr2ey4', // Replace with your Anon Key
    );
  }

  // --- AUTHENTICATION METHODS ---

  // Sign Up a new user and create their Profile
  static Future<String?> signUpUser(String email, String password, String fullName, String role) async {
    try {
      final AuthResponse res = await client.auth.signUp(
        email: email,
        password: password,
      );

      final User? user = res.user;

      if (user != null) {
        await client.from('profiles').insert({
          'id': user.id,
          'full_name': fullName,
          'role': role,
          'subscription_plan': role == 'member' ? 'Basic' : null,
          'subscription_status': role == 'member' ? 'Active' : null,
        });
        return null; // Returning null means SUCCESS (no errors)
      }
      return "Unknown error occurred during sign up.";
    } catch (e) {
      // Return the EXACT error from Supabase so we can see it on screen!
      return e.toString(); 
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
    required String imageUrl, // NEW: Parameter
  }) async {
    try {
      final endTime = startTime.add(Duration(minutes: durationMins));
      await client.from('classes').insert({
        'title': title,
        'category': tag,
        'difficulty_level': level,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'capacity': 20, // Default fallback
        'image_url': imageUrl, // Saved to DB
      });
      return true;
    } catch (e) {
      print("Create class error: $e");
      return false;
    }
  }

  // 3. Update an existing class
  static Future<bool> updateClass({
    required String classId,
    required String title,
    required String tag,
    required String level,
    required DateTime startTime,
    required int durationMins,
    required String imageUrl, // NEW: Parameter
  }) async {
    try {
      final endTime = startTime.add(Duration(minutes: durationMins));
      await client.from('classes').update({
        'title': title,
        'category': tag,
        'difficulty_level': level,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'image_url': imageUrl, // Updated in DB
      }).eq('id', classId);
      return true;
    } catch (e) {
      print("Update class error: $e");
      return false;
    }
  }

  // 4. Delete a class (For Coaches)
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

  // 5. Book a class (For Members)
  static Future<String?> bookClass(String classId, String classTitle) async {
    try {
      final userId = client.auth.currentUser!.id;
      
      // a. Insert the booking
      await client.from('bookings').insert({
        'user_id': userId,
        'class_id': classId,
      });

      // b. Generate the instant notification!
      await client.from('notifications').insert({
        'user_id': userId,
        'title': 'Class Confirmed!',
        'message': 'You are booked for $classTitle. Get ready to sweat!',
        'type': 'booking'
      });

      return null; // Success
    } catch (e) {
      return "Booking failed. You may already be booked during this time.";
    }
  }

  // --- ADMIN FUNCTIONS ---

  // 1. Get System Stats (Counts users, subs, and classes)
  static Future<Map<String, int>> getSystemStats() async {
    try {
      final users = await client.from('profiles').select('id').count(CountOption.exact);
      final subs = await client.from('profiles').select('id').eq('subscription_status', 'Active').count(CountOption.exact);
      
      // Get classes scheduled for the next 7 days
      final now = DateTime.now();
      final nextWeek = now.add(const Duration(days: 7));
      final classes = await client.from('classes')
          .select('id')
          .gte('start_time', now.toIso8601String())
          .lte('start_time', nextWeek.toIso8601String())
          .count(CountOption.exact);

      return {
        'totalUsers': users.count ?? 0,
        'activeSubs': subs.count ?? 0,
        'classesThisWeek': classes.count ?? 0,
      };
    } catch (e) {
      print("Error fetching stats: $e");
      return {'totalUsers': 0, 'activeSubs': 0, 'classesThisWeek': 0};
    }
  }

  // 2. Fetch all users in real-time
  static Stream<List<Map<String, dynamic>>> getAllUsersStream() {
    return client.from('profiles').stream(primaryKey: ['id']).order('full_name', ascending: true);
  }

  // 3. Change a user's role
  static Future<bool> updateUserRole(String userId, String newRole) async {
    try {
      await client.from('profiles').update({'role': newRole}).eq('id', userId);
      return true;
    } catch (e) {
      print("Error updating role: $e");
      return false;
    }
  }

  // 4. Delete a user profile
  static Future<bool> deleteUserProfile(String userId) async {
    try {
      // NOTE: For security, this deletes their public profile but keeps their secure Auth login. 
      // To fully delete an Auth user, you would eventually use a Supabase Edge Function.
      await client.from('profiles').delete().eq('id', userId);
      return true;
    } catch (e) {
      print("Error deleting user: $e");
      return false;
    }
  }

  // 5. Fetch payment plans in real-time
  static Stream<List<Map<String, dynamic>>> getPaymentPlansStream() {
    return client
        .from('subscription_plans')
        .stream(primaryKey: ['id'])
        .order('price', ascending: true); // Orders from cheapest to most expensive
  }

  // 6. Update a payment plan
  static Future<bool> updatePaymentPlan(String planId, double newPrice, bool isActive) async {
    try {
      await client.from('subscription_plans').update({
        'price': newPrice,
        'is_active': isActive,
      }).eq('id', planId);
      return true;
    } catch (e) {
      print("Error updating plan: $e");
      return false;
    }
  }


  // --- MEMBER FUNCTIONS ---

  // 1. Fetch the logged-in user's profile in real-time
  static Stream<Map<String, dynamic>> getCurrentUserProfileStream() {
    final userId = client.auth.currentUser!.id;
    // We map the list to just return the first (and only) row for this user
    return client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((rows) => rows.first);
  }

  // 2. Fetch classes specifically booked by the logged-in user
  static Future<List<Map<String, dynamic>>> getMyBookedClasses() async {
    try {
      final userId = client.auth.currentUser!.id;
      // This queries the junction table AND the related class data in one go!
      final response = await client
          .from('bookings')
          .select('classes(*)')
          .eq('user_id', userId);
          
      // Extract just the class data from the booking response
      return response.map((booking) => booking['classes'] as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching booked classes: $e");
      return [];
    }
  }

  // 3. Fetch active challenges
  static Stream<List<Map<String, dynamic>>> getChallengesStream() {
    return client.from('challenges').stream(primaryKey: ['id']);
  }

  // 4. Fetch the logged-in user's notifications in real-time
  static Stream<List<Map<String, dynamic>>> getNotificationsStream() {
    final userId = client.auth.currentUser!.id;
    return client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false); // Newest first
  }

  // 5. Mark a single notification as read
  static Future<void> markNotificationRead(String notificationId) async {
    try {
      await client.from('notifications').update({'is_read': true}).eq('id', notificationId);
    } catch (e) {
      print("Error marking notification read: $e");
    }
  }

  // 6. Mark ALL notifications as read
  static Future<void> markAllNotificationsRead() async {
    try {
      final userId = client.auth.currentUser!.id;
      await client.from('notifications').update({'is_read': true}).eq('user_id', userId);
    } catch (e) {
      print("Error marking all read: $e");
    }
  }

  // 7. Delete a notification
  static Future<void> deleteNotification(String notificationId) async {
    try {
      await client.from('notifications').delete().eq('id', notificationId);
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  // --- COACH FUNCTIONS ---

  // 1. Create a new challenge
  static Future<bool> createChallenge({
    required String title,
    required String description,
    required int durationDays,
    required String category,
    required String level,
    required String imageUrl, // Added parameter
  }) async {
    try {
      await client.from('challenges').insert({
        'title': title,
        'description': description,
        'days_left': durationDays,
        'total_goal': durationDays,
        'reward': 'Gym Merch',
        'category': category,
        'level': level,
        'tag_color': 'orange',
        'image_url': imageUrl, // Saved to DB
      });
      return true;
    } catch (e) {
      print("Error creating challenge: $e");
      return false;
    }
  }

  // 2. Update an existing challenge
  static Future<bool> updateChallenge({
    required String id,
    required String title,
    required String description,
    required int durationDays,
    required String category,
    required String level,
    required String imageUrl, // Added parameter
  }) async {
    try {
      await client.from('challenges').update({
        'title': title,
        'description': description,
        'days_left': durationDays,
        'category': category,
        'level': level,
        'image_url': imageUrl, // Updated in DB
      }).eq('id', id);
      return true;
    } catch (e) {
      print("Error updating challenge: $e");
      return false;
    }
  }

  // 3. Delete a challenge
  static Future<bool> deleteChallenge(String id) async {
    try {
      await client.from('challenges').delete().eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }


  // 4. Get a single class by ID
  static Future<Map<String, dynamic>?> getClassById(String id) async {
    try {
      return await client.from('classes').select().eq('id', id).single();
    } catch (e) {
      return null;
    }
  }
  

  // 6. Get Coach Profile
  static Future<Map<String, dynamic>?> getCoachProfile(String coachId) async {
    try {
      return await client.from('profiles').select().eq('id', coachId).single();
    } catch (e) {
      return null;
    }
  }

  // 7. Update Coach Profile
  static Future<bool> updateCoachProfile({
    required String fullName,
    required String bio,
    required String avatarUrl,
    required List<String> certificates,
    required List<String> expertise,
  }) async {
    try {
      await client.from('profiles').update({
        'full_name': fullName,
        'bio': bio,
        'avatar_url': avatarUrl,
        'certificates': certificates,
        'expertise': expertise,
      }).eq('id', client.auth.currentUser!.id);
      return true;
    } catch (e) {
      print("Profile update error: $e");
      return false;
    }
  }
}