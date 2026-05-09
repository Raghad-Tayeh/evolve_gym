import 'package:flutter/material.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> challenge;

  const ChallengeDetailScreen({super.key, required this.challenge});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isActive = widget.challenge["status"] == "Active";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge["title"]),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(widget.challenge["imageUrl"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "About this challenge",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Text(
                    "Start day: ${widget.challenge["startDate"]}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.challenge["description"],
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 20),

              const Text(
                "Challenge Goals",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 10),
              _buildGoalRow(
                Icons.check_circle_outline,
                "Complete consecutive days of workouts",
              ),
              _buildGoalRow(
                Icons.check_circle_outline,
                "Master advanced exercises",
              ),
              _buildGoalRow(
                Icons.check_circle_outline,
                "Build visible definition",
              ),
              const SizedBox(height: 30),

              if (!isActive)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.challenge["status"] = "Active";
                        widget.challenge["progress"] = 0.05; // Start at 5%
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Challenge Joined! Time to work!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text(
                      "Join Challenge",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.greenAccent),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Continue Workout",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
