import 'package:evolve_gym/screens/admin/payment_plans_view.dart';
import 'package:evolve_gym/screens/admin/system_usage_view.dart';
import 'package:evolve_gym/screens/admin/user_management_view.dart';
import 'package:evolve_gym/screens/coach/coach_challenges_screen.dart';
import 'package:flutter/material.dart';
import 'package:evolve_gym/appcolors.dart'; // Assuming your custom colors are here

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  // List of views corresponding to your requirements
  final List<Widget> _adminViews = [
    const SystemUsageView(),
    const UserManagementView(),
    const CoachChallengesScreen(),
    const PaymentPlansView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Or AppColors.background
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 250,
            color: const Color(0xFF1E1E1E), // Or AppColors.surface
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "EVOLVE ADMIN",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildNavItem(Icons.dashboard_rounded, "System Usage", 0),
                _buildNavItem(Icons.people_alt_rounded, "Manage Users", 1),
                _buildNavItem(Icons.fitness_center_rounded, "Manage Classes", 2),
                _buildNavItem(Icons.payment_rounded, "Payment Plans", 3),
                const Spacer(),
                _buildNavItem(Icons.logout_rounded, "Logout", 4, isLogout: true),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              child: _adminViews[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index, {bool isLogout = false}) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon, 
        color: isLogout ? Colors.redAccent : (isSelected ? Colors.greenAccent : Colors.grey)
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.redAccent : (isSelected ? Colors.white : Colors.grey),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        if (isLogout) {
          // Handle Logout logic & navigation here
        } else {
          setState(() => _selectedIndex = index);
        }
      },
    );
  }
}