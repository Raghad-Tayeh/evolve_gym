// main.dart  (drop into your lib/ folder)
//
// This file is a standalone demo entry point.
// In your real app, wire MemberChallengesScreen / CoachChallengesScreen
// into your existing navigation/routing instead.

import 'package:flutter/material.dart';
import 'screens/member/member_challenges_screen.dart';
import 'screens/coach/coach_challenges_screen.dart';

void main() => runApp(const EvolveGymChallengesDemo());

class EvolveGymChallengesDemo extends StatelessWidget {
  const EvolveGymChallengesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evolve Gym – Challenges',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent,
          surface: Color(0xFF1E1E1E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        fontFamily: 'Roboto',
      ),
      home: const _RoleSwitcher(),
    );
  }
}

/// Simple role-switcher for testing both views.
/// Remove this in production and navigate directly to the desired screen.
class _RoleSwitcher extends StatefulWidget {
  const _RoleSwitcher();

  @override
  State<_RoleSwitcher> createState() => _RoleSwitcherState();
}

class _RoleSwitcherState extends State<_RoleSwitcher> {
  bool _isCoach = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          // The actual screen
          _isCoach
              ? const CoachChallengesScreen()
              : const MemberChallengesScreen(),

          // Role switcher pill (top-center, for demo only)
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RoleTab(
                      label: '👤  Member',
                      active: !_isCoach,
                      onTap: () => setState(() => _isCoach = false),
                    ),
                    _RoleTab(
                      label: '🏋️  Coach',
                      active: _isCoach,
                      onTap: () => setState(() => _isCoach = true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _RoleTab(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.greenAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white54,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
