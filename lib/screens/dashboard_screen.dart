import 'package:flutter/material.dart';
import 'classes_screen.dart';
import 'settings_screen.dart';
import 'add_class_screen.dart';
import 'coach/coach_challenges_screen.dart';
import 'member/member_challenges_screen.dart';

class DashboardScreen extends StatelessWidget {
  final bool isCoach;
  const DashboardScreen({super.key, required this.isCoach});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCoach ? "Coach Dashboard" : "Member Dashboard"),
        actions: [
          if (!isCoach)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCoach ? Icons.sports : Icons.person,
              size: 80,
              color: Colors.greenAccent,
            ),
            const SizedBox(height: 20),
            Text(
              isCoach ? "Welcome Back, Coach!" : "Ready to Train?",
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
              label: Text(isCoach ? "View My Schedule" : "View Classes"),
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
              label: Text(isCoach ? "Manage Challenges" : "Join a Challenge"),
              onPressed: () {
                // Route dynamically based on role using the new folder structure!
                if (isCoach) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // IMPORTANT: No 'const' keyword here
                      builder: (context) => CoachChallengesScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // IMPORTANT: No 'const' keyword here
                      builder: (context) => MemberChallengesScreen(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // Existing Add Class Button
            if (isCoach)
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
