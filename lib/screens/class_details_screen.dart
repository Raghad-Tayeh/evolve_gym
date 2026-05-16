import 'package:evolve_gym/screens/add_class_screen.dart';
import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart'; // Import your service
import 'coach/coach_details_screen.dart';

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
  // Add a loading state
  bool _isLoading = false;

  // Function to handle booking (Members)
  Future<void> _handleBooking() async {
    setState(() => _isLoading = true);

    // NEW: We now pass widget.title to the function so it can send the notification!
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
      // Show the overlapping time error (or any other DB error)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
      );
    }
  }

  // Function to handle canceling (Coaches)
  Future<void> _handleCancel() async {
    setState(() => _isLoading = true);

    // Call the backend function we built
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
      Navigator.pop(context); // Go back to the schedule
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
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(label: Text(widget.tag), backgroundColor: Colors.blueGrey),
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
              style: TextStyle(fontSize: 14, height: 1.5),
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
                    subtitle: Text("Manage your class effectively."),
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("HIIT & Strength"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
                        // Navigate to the editor, passing the current Class ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddClassScreen(classId: widget.classId),
                          ),
                        ).then(
                          (_) => Navigator.pop(context),
                        ); // Pop back so schedule refreshes
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
