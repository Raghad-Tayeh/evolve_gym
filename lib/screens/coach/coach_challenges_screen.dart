import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart';
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
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateChallengeScreen(), 
            ),
          ); 
        },
        backgroundColor: Colors.greenAccent,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          "New Challenge",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      // NEW: Real-time database listener
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: SupabaseService.getChallengesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
          }

          final challenges = snapshot.data ?? [];

          if (challenges.isEmpty) {
            return const Center(child: Text("No challenges active. Create one!", style: TextStyle(color: Colors.grey)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              return _buildCoachChallengeCard(challenges[index]);
            },
          );
        }
      ),
    );
  }

  Widget _buildCoachChallengeCard(Map<String, dynamic> challenge) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateChallengeScreen(challenge: challenge),
            ),
          );
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
                    image: NetworkImage(challenge["image_url"] ?? "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80"),
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
                          challenge["level"] ?? "Beginner",
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: Colors.black54,
                      ),
                      Chip(
                        label: const Text(
                          "Edit",
                          style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.greenAccent,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                challenge["category"] ?? "Lifestyle",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                challenge["title"] ?? "Unnamed Challenge",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                challenge["description"] ?? "No description provided.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${challenge["days_left"] ?? 0} Days",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  // Added a quick delete button for the coach
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: () => SupabaseService.deleteChallenge(challenge['id']),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}