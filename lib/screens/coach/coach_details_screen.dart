import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart';

class CoachDetailsScreen extends StatefulWidget {
  final String? coachId; // If null, loads current user (for coaches editing their own profile)
  
  const CoachDetailsScreen({super.key, this.coachId});

  @override
  State<CoachDetailsScreen> createState() => _CoachDetailsScreenState();
}

class _CoachDetailsScreenState extends State<CoachDetailsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _profile;
  bool _isMe = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    
    // If no ID is passed, assume the current logged-in user is checking their own profile
    final targetId = widget.coachId ?? SupabaseService.client.auth.currentUser!.id;
    
    // Check if the profile being viewed belongs to the person holding the phone
    _isMe = targetId == SupabaseService.client.auth.currentUser!.id;

    _profile = await SupabaseService.getCoachProfile(targetId);
    setState(() => _isLoading = false);
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: _profile?['full_name'] ?? '');
    final avatarController = TextEditingController(text: _profile?['avatar_url'] ?? '');
    final bioController = TextEditingController(text: _profile?['bio'] ?? '');
    
    // Convert List array from database to comma separated string for easy typing
    final certsController = TextEditingController(text: (_profile?['certificates'] as List<dynamic>? ?? []).join(', '));
    final expController = TextEditingController(text: (_profile?['expertise'] as List<dynamic>? ?? []).join(', '));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Edit Profile Data", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Display Full Name", labelStyle: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: avatarController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Profile Picture URL", labelStyle: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bioController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Biography Bio", labelStyle: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: certsController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Certificates (comma separated)", labelStyle: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: expController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Expertise (comma separated)", labelStyle: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
            onPressed: () async {
              // Convert the comma separated strings back into a clean List for the database
              final certs = certsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
              final exp = expController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
              
              final success = await SupabaseService.updateCoachProfile(
                fullName: nameController.text.trim(),
                avatarUrl: avatarController.text.trim(),
                bio: bioController.text.trim(),
                certificates: certs,
                expertise: exp,
              );
              
              if (success && mounted) {
                Navigator.pop(context);
                _loadProfile(); // Refresh screen view elements to show changes instantly
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.greenAccent)));
    }

    if (_profile == null) {
      return const Scaffold(body: Center(child: Text("Profile data trace not found.")));
    }

    final certs = _profile?['certificates'] as List<dynamic>? ?? [];
    final exp = _profile?['expertise'] as List<dynamic>? ?? [];
    final avatarUrl = _profile?['avatar_url'] ?? "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Coach Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_isMe) // Only show the edit button if the Coach is looking at themselves
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.greenAccent),
              onPressed: _showEditDialog,
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _profile?['full_name'] ?? "Coach Account",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            const Text("Bio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
            const SizedBox(height: 8),
            Text(_profile?['bio'] ?? "No biography details available."),
            const SizedBox(height: 24),

            const Text("Certificates", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
            const SizedBox(height: 8),
            certs.isEmpty 
              ? const Text("No credentials submitted.", style: TextStyle(color: Colors.grey))
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: certs.map((c) => Chip(label: Text(c.toString()), backgroundColor: Colors.blueGrey)).toList(),
                ),
            const SizedBox(height: 24),

            const Text("Training Expertise", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
            const SizedBox(height: 8),
            exp.isEmpty 
              ? const Text("No specializations declared.", style: TextStyle(color: Colors.grey))
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: exp.map((e) => Chip(label: Text(e.toString()), backgroundColor: Colors.blueGrey)).toList(),
                ),
          ],
        ),
      ),
    );
  }
}