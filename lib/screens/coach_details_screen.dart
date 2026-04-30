import 'package:flutter/material.dart';

class CoachDetailsScreen extends StatelessWidget {
  const CoachDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Coach Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=1470&auto=format&fit=crop",
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "Marcus Rodriguez",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Bio",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "With over 8 years of experience, I am dedicated to helping people transform their lives through movement and strength training.",
            ),
            const SizedBox(height: 24),

            const Text(
              "Certificates",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text("NASM CPT")),
                Chip(label: Text("CrossFit Level 2")),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              "Training Expertise",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text("HIIT")),
                Chip(label: Text("Strength & Conditioning")),
                Chip(label: Text("Weight Loss")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
