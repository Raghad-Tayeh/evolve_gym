import 'package:flutter/material.dart';
import '../../models/challenge_model.dart';
import 'create_challenge_screen.dart';

class CoachChallengesScreen extends StatefulWidget {
  const CoachChallengesScreen({super.key});

  @override
  State<CoachChallengesScreen> createState() => _CoachChallengesScreenState();
}

class _CoachChallengesScreenState extends State<CoachChallengesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Challenges"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Action Button to Create a completely new Challenge
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const CreateChallengeScreen(), // Null means Create
            ),
          ).then((_) => setState(() {})); // Refresh list on return
        },
        backgroundColor: Colors.greenAccent,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          "New Challenge",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: globalChallenges.length,
        itemBuilder: (context, index) {
          final challenge = globalChallenges[index];
          return _buildCoachChallengeCard(challenge);
        },
      ),
    );
  }

  // Custom card specifically for the Coach (No member data)
  Widget _buildCoachChallengeCard(Map<String, dynamic> challenge) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Tapping opens the EDIT form and passes the existing data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateChallengeScreen(challenge: challenge),
            ),
          ).then((_) => setState(() {})); // Refresh list on return
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(challenge["imageUrl"]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          challenge["level"],
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: Colors.black54,
                      ),
                      Chip(
                        label: const Text(
                          "Edit",
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        backgroundColor: Colors.greenAccent,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                challenge["category"],
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                challenge["title"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                challenge["description"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    challenge["duration"],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
