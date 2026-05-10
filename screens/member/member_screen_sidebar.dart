import 'package:evolve_gym/screens/member/dashboard_screen.dart';
import 'package:flutter/material.dart';
import '../classes_screen.dart';
import '../settings_screen.dart';
import '../add_class_screen.dart';
import 'package:evolve_gym/appcolors.dart';

// ---- Sidebar implementation ------

class MemberScreenSidebar extends StatefulWidget {
  final bool isCoach;
  const MemberScreenSidebar({super.key, required this.isCoach});

  @override
  State<MemberScreenSidebar> createState() => _MemberScreenSidebarState();
}

class _MemberScreenSidebarState extends State<MemberScreenSidebar> {
  int _selectedIndex = 0;

  // Define the different views that will swap in on the right side
  final List<Widget> _views = [
    MemberDashboard(),
    const Center(child: ClassesScreen()),
    const Center(
      child: Text(
        'Challenges View',
        style: TextStyle(color: AppColors.textPrimary, fontSize: 24),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Row(
        children: [
          _buildSideBar(),
          Expanded(child: _views[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final isSelected = _selectedIndex == index;

    return IconButton(
      icon: Icon(
        icon,
        // Highlight logic: green if selected, grey if not
        color: isSelected ? AppColors.accent : AppColors.textSecondary,
      ),
      onPressed: () {
        // setState tells Flutter to rebuild the screen with the new index
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  } // Close _buildNavItem

  Widget _buildSideBar() {
    final bottomIcons = [Icons.settings_rounded, Icons.logout_rounded];

    return Container(
      width: 64,
      color: AppColors.surface,
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(
                74,
                222,
                128,
                1,
              ).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: AppColors.accent,
              size: 20,
            ),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavItem(icon: Icons.grid_view_rounded, index: 0),
                const SizedBox(height: 4),
                _buildNavItem(icon: Icons.calendar_today_rounded, index: 1),
                const SizedBox(height: 4),
                _buildNavItem(icon: Icons.emoji_events_rounded, index: 2),
              ],
            ),
          ),

          // Bottom of Sidebar
          IconButton(icon: Icon(bottomIcons[0]), onPressed: () {}),
          IconButton(icon: Icon(bottomIcons[1]), onPressed: () {}),

          const SizedBox(height: 6),

          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.cardioPurple, AppColors.backTeal],
              ),
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  } // Close _buildSideBar
}
