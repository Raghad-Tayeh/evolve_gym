import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart';
// import 'package:evolve_gym/screens/member/subscription_screen.dart'; // Uncomment this to link the upgrade button!

class ChallengeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> challenge;

  const ChallengeDetailScreen({super.key, required this.challenge});

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  
  // --- THE BOUNCER LOGIC ---
  Future<void> _handleProtectedAction(VoidCallback onSuccess) async {
    // 1. Show a quick loading spinner while we check the database
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
    );

    try {
      // 2. Fetch the user's latest profile data
      final userId = SupabaseService.client.auth.currentUser!.id;
      final profile = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      if (!mounted) return;
      Navigator.pop(context); // Close the loader

      // 3. Check access using the helper function we built
      final bool canAccess = SupabaseService.hasActiveAccess(profile);

      if (canAccess) {
        // --- SUCCESS PATH ---
        onSuccess();
      } else {
        // --- SOFT LOCK PATH ---
        _showUpgradePrompt();
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      print("Error checking access: $e");
    }
  }

  void _showUpgradePrompt() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 48, color: Colors.orangeAccent),
              const SizedBox(height: 16),
              const Text(
                "Subscription Required",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your gym membership is currently inactive. Renew your plan to unlock premium challenges and track your progress!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the modal
                    
                    // TODO: Navigate to the subscription screen so they can pay!
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionScreen()));
                  },
                  child: const Text("View Plans", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = widget.challenge["status"] == "Active";

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
                style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
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
              _buildGoalRow(Icons.check_circle_outline, "Complete consecutive days of workouts"),
              _buildGoalRow(Icons.check_circle_outline, "Master advanced exercises"),
              _buildGoalRow(Icons.check_circle_outline, "Build visible definition"),
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
                      // Trigger the bouncer before joining
                      _handleProtectedAction(() {
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
                      });
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
                    onPressed: () {
                      // Trigger the bouncer before continuing, just in case their sub expired mid-challenge
                      _handleProtectedAction(() {
                        // Add navigation to workout screen here
                        print("Continuing workout...");
                      });
                    },
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