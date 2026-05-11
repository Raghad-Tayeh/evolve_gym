import 'package:flutter/material.dart';
import '../classes_screen.dart';
import '../settings_screen.dart';
import '../add_class_screen.dart';
import 'coach_challenges_screen.dart';
import '../member/member_challenges_screen.dart';
import 'package:evolve_gym/appcolors.dart';

class CoachDashboardScreen extends StatelessWidget {
  final bool isCoach;
  const CoachDashboardScreen({super.key, required this.isCoach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surfaceElevated,
        title: Text("Coach Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.logout_rounded), onPressed: () {}),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports, size: 80, color: Colors.greenAccent),
            const SizedBox(height: 20),
            Text(
              "Welcome Back, Coach!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Existing Classes Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              icon: const Icon(Icons.list),
              label: Text("View My Schedule"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassesScreen(isCoach: isCoach),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // ✨ UPDATED Challenges Button with New Routing ✨
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800],
                foregroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              icon: const Icon(Icons.emoji_events),
              label: Text("Manage Challenges"),
              onPressed: () {
                // Route dynamically based on role using the new folder structure!
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // IMPORTANT: No 'const' keyword here
                    builder: (context) => CoachChallengesScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Existing Add Class Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text("Add New Class"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddClassScreen(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
