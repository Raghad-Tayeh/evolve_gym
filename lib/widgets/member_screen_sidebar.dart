import 'package:evolve_gym/screens/member/member_challenges_screen.dart';
import 'package:evolve_gym/screens/member/notifications_screen.dart';
import 'package:evolve_gym/services/change_password_screen.dart';
import 'package:evolve_gym/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:evolve_gym/screens/classes_screen.dart';
import 'package:evolve_gym/appcolors.dart';
import 'package:evolve_gym/screens/member/member_dashboard_screen.dart';
import 'package:evolve_gym/screens/login_screen.dart';

class MemberScreenSidebar extends StatefulWidget {
  const MemberScreenSidebar({super.key});

  @override
  State<MemberScreenSidebar> createState() => _MemberScreenSidebarState();
}

class _MemberScreenSidebarState extends State<MemberScreenSidebar> {
  int _selectedIndex = 0;

  final List<Widget> _views = [
    const MemberDashboardScreen(),
    Center(child: ClassesScreen(isCoach: false)),
    const Center(child: MemberChallengesScreen()),
    const NotificationsScreen(),
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

                // ── Dynamic Live-Connected Bell Notification Icon ───────────────────────
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: SupabaseService.getNotificationsStream(),
                  builder: (context, snapshot) {
                    // Count entries where is_read is strictly false
                    final dbNotifications = snapshot.data ?? [];
                    final dynamicUnreadCount = dbNotifications.where((n) => n['is_read'] == false).length;

                    return Stack(
                      children: [
                        _buildNavItem(
                          icon: Icons.notifications_none_rounded,
                          index: 3,
                        ),
                        if (dynamicUnreadCount > 0)
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
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom icons — unchanged
          IconButton(icon: Icon(bottomIcons[0]), onPressed: ()  {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
            );
          }),
          IconButton(
            icon: Icon(bottomIcons[1]), 
            onPressed: () async {
              // 1. Log out from Supabase
              await SupabaseService.logoutUser();
              
              // 2. Navigate back to Login Screen
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),

          const SizedBox(height: 6),

        ],
      ),
    );
  }
}