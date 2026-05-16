// lib/widgets/member_screen_sidebar.dart

import 'package:evolve_gym/screens/member/member_challenges_screen.dart';
import 'package:evolve_gym/screens/member/notifications_screen.dart';
import 'package:evolve_gym/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:evolve_gym/screens/classes_screen.dart';
import 'package:evolve_gym/appcolors.dart';
import 'package:evolve_gym/screens/member/member_dashboard_screen.dart';

class MemberScreenSidebar extends StatefulWidget {
  const MemberScreenSidebar({super.key});

  @override
  State<MemberScreenSidebar> createState() => _MemberScreenSidebarState();
}

class _MemberScreenSidebarState extends State<MemberScreenSidebar> {
  int _selectedIndex = 0;

  // Unread count drives the red dot on the bell icon
  int get _unreadCount =>
      dummyNotifications.where((n) => !n.isRead).length;

  final List<Widget> _views = [
    MemberDashboardScreen(),
    const Center(child: ClassesScreen()),
    const Center(child: MemberChallengesScreen()),
    const NotificationsScreen(), // ← new
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
        color: isSelected ? AppColors.accent : AppColors.textSecondary,
      ),
      onPressed: () => setState(() => _selectedIndex = index),
    );
  }

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
              color: const Color.fromRGBO(74, 222, 128, 1).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
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
                const SizedBox(height: 4),

                // ── Bell icon with unread dot ───────────────────────
                Stack(
                  children: [
                    _buildNavItem(
                      icon: Icons.notifications_none_rounded,
                      index: 3,
                    ),
                    if (_unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.armsRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom icons — unchanged
          IconButton(icon: Icon(bottomIcons[0]), onPressed: () {}),
          IconButton(icon: Icon(bottomIcons[1]), onPressed: () {}),

          const SizedBox(height: 6),

          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
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
  }
}
