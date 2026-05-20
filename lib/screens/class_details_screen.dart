import 'package:evolve_gym/screens/add_class_screen.dart';
import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart';
import 'coach/coach_details_screen.dart';
// import 'package:evolve_gym/screens/member/subscription_screen.dart'; // Uncomment to link the upgrade button!

class ClassDetailsScreen extends StatefulWidget {
  final String classId;
  final String title;
  final String tag;
  final String duration;
  final bool isCoach;

  const ClassDetailsScreen({
    super.key,
    required this.classId,
    required this.title,
    required this.tag,
    required this.duration,
    required this.isCoach,
  });

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  bool _isLoading = false;

  // --- THE BOUNCER & BOOKING LOGIC COMBINED ---
  Future<void> _handleBooking() async {
    setState(() => _isLoading = true);

    try {
      // 1. Fetch the user's latest profile data to check subscription status
      final userId = SupabaseService.client.auth.currentUser!.id;
      final profile = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      // 2. Check access using the helper function
      final bool canAccess = SupabaseService.hasActiveAccess(profile);

      if (!canAccess) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showUpgradePrompt(); // Stop booking and show the paywall
        return;
      }

      // 3. SUCCESS PATH: Proceed with booking
      final error = await SupabaseService.bookClass(widget.classId, widget.title);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Class Booked Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to the schedule
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      print("Booking error: $e");
    }
  }

  // --- THE UPGRADE PROMPT ---
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
                "Your gym membership has expired or is inactive. Renew your plan to unlock class bookings!",
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

  // Function to handle canceling (Coaches)
  Future<void> _handleCancel() async {
    setState(() => _isLoading = true);

    final success = await SupabaseService.deleteClass(widget.classId);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Class Cancelled."),
          backgroundColor: Colors.redAccent,
        ),
      );
      Navigator.pop(context); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to cancel class."),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Keep consistent dark theme
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=1470&auto=format&fit=crop",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(widget.tag, style: const TextStyle(color: Colors.white)), 
                  backgroundColor: Colors.blueGrey,
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Duration: ${widget.duration} • Location: Studio A",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "About this class",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Join us for an intense and rewarding session designed to push your limits and build endurance.",
              style: TextStyle(fontSize: 14, height: 1.5, color: Colors.white70),
            ),
            const SizedBox(height: 20),

            const Text(
              "Coach",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 10),
            widget.isCoach
                ? const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                    title: Text(
                      "Instructor: You",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                    subtitle: Text("Manage your class effectively.", style: TextStyle(color: Colors.grey)),
                  )
                : ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=1470&auto=format&fit=crop",
                      ),
                    ),
                    title: const Text(
                      "Marcus Rodriguez",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: const Text("HIIT & Strength", style: TextStyle(color: Colors.grey)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CoachDetailsScreen(),
                        ),
                      );
                    },
                  ),

            const Spacer(),

            // Dynamic Button based on Role
            if (!widget.isCoach)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isLoading ? null : _handleBooking,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Confirm Booking",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.blueAccent),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddClassScreen(classId: widget.classId),
                          ),
                        ).then((_) => Navigator.pop(context)); 
                      },
                      child: const Text(
                        "Edit Class",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      onPressed: _isLoading ? null : _handleCancel,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.redAccent,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Cancel Class",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}