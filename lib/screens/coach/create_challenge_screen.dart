import 'package:evolve_gym/services/supabase_service.dart';
import 'package:flutter/material.dart';

class CreateChallengeScreen extends StatefulWidget {
  final Map<String, dynamic>? challenge;

  const CreateChallengeScreen({super.key, this.challenge});

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _durationController;
  late TextEditingController _imageUrlController; // NEW: Image URL controller

  String selectedLevel = 'Beginner';
  String selectedCategory = 'Lifestyle';
  bool _isLoading = false;

  final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> categories = ['Lifestyle', 'Cardio', 'Flexibility', 'Strength'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.challenge?['title'] ?? "");
    _descController = TextEditingController(text: widget.challenge?['description'] ?? "");
    
    String durationRaw = widget.challenge?['days_left']?.toString() ?? "";
    _durationController = TextEditingController(text: durationRaw);

    // Pre-fill the image URL if editing, or default to a clean placeholder
    _imageUrlController = TextEditingController(
      text: widget.challenge?['image_url'] ?? "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80"
    );

    if (widget.challenge != null) {
      selectedLevel = widget.challenge!['level'] ?? 'Beginner';
      selectedCategory = widget.challenge!['category'] ?? 'Lifestyle';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _imageUrlController.dispose(); // Dispose the new controller
    super.dispose();
  }

  Future<void> _saveChallenge() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final duration = int.tryParse(_durationController.text) ?? 30;
      final imageUrl = _imageUrlController.text.trim();

      bool success;
      if (widget.challenge == null) {
        // --- CREATE IN DATABASE ---
        success = await SupabaseService.createChallenge(
          title: _titleController.text,
          description: _descController.text,
          durationDays: duration,
          category: selectedCategory,
          level: selectedLevel,
          imageUrl: imageUrl, // Pass image URL
        );
      } else {
        // --- UPDATE IN DATABASE ---
        success = await SupabaseService.updateChallenge(
          id: widget.challenge!['id'],
          title: _titleController.text,
          description: _descController.text,
          durationDays: duration,
          category: selectedCategory,
          level: selectedLevel,
          imageUrl: imageUrl, // Pass image URL
        );
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.challenge == null ? "Challenge Published!" : "Challenge Saved!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save challenge."), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.challenge != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Challenge" : "Create New Challenge"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Challenge Title"),
                validator: (value) => value!.isEmpty ? "Title is required" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: "Category"),
                      items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                      onChanged: (val) => setState(() => selectedCategory = val!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedLevel,
                      decoration: const InputDecoration(labelText: "Difficulty Level"),
                      items: levels.map((lvl) => DropdownMenuItem(value: lvl, child: Text(lvl))).toList(),
                      onChanged: (val) => setState(() => selectedLevel = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Duration (in days)"),
                validator: (value) => value!.isEmpty ? "Duration is required" : null,
              ),
              const SizedBox(height: 16),
              
              // NEW: Image URL input field
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: "Cover Image URL",
                  hintText: "Paste an Unsplash image link here",
                ),
                validator: (value) => value!.isEmpty ? "An image link is required" : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Challenge Description",
                  alignLabelWithHint: true,
                ),
                validator: (value) => value!.isEmpty ? "Description is required" : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isLoading ? null : _saveChallenge,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(
                        isEditing ? "Save Changes" : "Publish Challenge",
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}