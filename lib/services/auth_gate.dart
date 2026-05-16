import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart'; // Adjust path if needed
import 'package:evolve_gym/screens/admin/admin_dashboard.dart';
import 'package:evolve_gym/widgets/member_screen_sidebar.dart';
import 'package:evolve_gym/screens/coach/coach_dashboard_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // This function fetches the user's profile from the database
  Future<Map<String, dynamic>> _getUserProfile() async {
    final userId = SupabaseService.client.auth.currentUser!.id;
    
    final response = await SupabaseService.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
        
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserProfile(),
      builder: (context, snapshot) {
        // 1. Show a loading spinner while we check the database
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            ),
          );
        }

        // 2. Handle errors (e.g., no internet)
        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text("Error loading profile. Please restart.", style: TextStyle(color: Colors.white)),
            ),
          );
        }

        // 3. We have the data! Check the role.
        final role = snapshot.data!['role'];

        // 4. Route them to the correct screen based on their database role
        if (role == 'admin') {
          return const AdminDashboardScreen();
        } else if (role == 'coach') {
          return const CoachDashboardScreen(isCoach: true); 
        } else {
          // Default to the Member UI
          return const MemberScreenSidebar();
        }
      },
    );
  }
}