import 'package:flutter/material.dart';
import 'classes_screen.dart';
import 'settings_screen.dart';
import 'add_class_screen.dart';

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
