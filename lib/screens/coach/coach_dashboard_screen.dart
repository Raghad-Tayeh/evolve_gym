import 'package:evolve_gym/screens/add_class_screen.dart';
import 'package:evolve_gym/screens/classes_screen.dart';
import 'package:evolve_gym/screens/coach/coach_challenges_screen.dart';
import 'package:evolve_gym/screens/coach/coach_details_screen.dart'; // Imported CoachDetailsScreen
import 'package:evolve_gym/screens/login_screen.dart';
import 'package:evolve_gym/services/change_password_screen.dart';
import 'package:evolve_gym/services/supabase_service.dart';
import 'package:flutter/material.dart';

class CoachDashboardScreen extends StatefulWidget {
  final bool isCoach;
  const CoachDashboardScreen({super.key, required this.isCoach});

  @override
  State<CoachDashboardScreen> createState() => _CoachDashboardScreenState();
}

class _CoachDashboardScreenState extends State<CoachDashboardScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _coachViews;

  @override
  void initState() {
    super.initState();
    _coachViews = [
      ClassesScreen(isCoach: widget.isCoach), // Index 0: Default Home View Schedule Panel
      const CoachChallengesScreen(),          // Index 1: Live Event Challenges Panel
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // Sidebar Navigation Shell
          Container(
            width: 250,
            color: const Color(0xFF1E1E1E),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "EVOLVE COACH",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildSidebarItem(Icons.list_alt_rounded, "My Schedule", 0),
                
                // ── ACTION OVERLAYS: Open modally above current workspace ──
                _buildSidebarActionItem(
                  Icons.add_circle_outline_rounded, 
                  "Add New Class", 
                  targetScreen: const AddClassScreen(),
                ),
                
                // ── NEW PROFILE MANAGEMENT SHORTCUT ──
                _buildSidebarActionItem(
                  Icons.person_outline_rounded, 
                  "Edit My Profile", 
                  targetScreen: const CoachDetailsScreen(), // Loads logged in Coach profile automatically
                ),
                
                _buildSidebarItem(Icons.emoji_events_rounded, "Manage Challenges", 1),
                
                _buildSidebarActionItem(
                  Icons.settings_rounded, 
                  "Change Password", 
                  targetScreen: const ChangePasswordScreen(),
                ),
                
                const Spacer(),
                _buildSidebarItem(Icons.logout_rounded, "Logout", 2, isLogout: true),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Main Panel Focus Target View Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              child: _coachViews[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, int index, {bool isLogout = false}) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.redAccent : (isSelected ? Colors.greenAccent : Colors.grey),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.redAccent : (isSelected ? Colors.white : Colors.grey),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () async {
        if (isLogout) {
          await SupabaseService.logoutUser();
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        } else {
          setState(() => _selectedIndex = index);
        }
      },
    );
  }

  // Unified routing action terminal wrapper
  Widget _buildSidebarActionItem(IconData icon, String title, {required Widget targetScreen}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
    );
  }
}