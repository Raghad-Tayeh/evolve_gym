import 'package:flutter/material.dart';
import '../../models/challenge_model.dart'; // Connects to your global data

class CreateChallengeScreen extends StatefulWidget {
  // If this is passed data, it acts as an Edit page. If null, it creates.
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

  String selectedLevel = 'Beginner';
  String selectedCategory = 'Lifestyle';

  final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> categories = [
    'Lifestyle',
    'Cardio',
    'Flexibility',
    'Strength',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if we are editing an existing challenge!
    _titleController = TextEditingController(
      text: widget.challenge?['title'] ?? "",
    );
    _descController = TextEditingController(
      text: widget.challenge?['description'] ?? "",
    );

    // Clean up duration text just in case it says "30 days" instead of just "30"
    String durationRaw = widget.challenge?['duration'] ?? "";
    _durationController = TextEditingController(
      text: durationRaw.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    if (widget.challenge != null) {
      selectedLevel = widget.challenge!['level'];
      selectedCategory = widget.challenge!['category'];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveChallenge() {
    if (_formKey.currentState!.validate()) {
      if (widget.challenge == null) {
        // --- CREATE A BRAND NEW CHALLENGE ---
        globalChallenges.add({
          "id": DateTime.now().toString(),
          "title": _titleController.text,
          "category": selectedCategory,
          "level": selectedLevel,
          "status": "New",
          "duration": "${_durationController.text} Days",
          "description": _descController.text,
          "startDate": "Upcoming",
          "imageUrl":
              "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=1470&auto=format&fit=crop",
        });
      } else {
        // --- UPDATE THE EXISTING CHALLENGE ---
        setState(() {
          widget.challenge!['title'] = _titleController.text;
          widget.challenge!['description'] = _descController.text;
          widget.challenge!['duration'] = "${_durationController.text} Days";
          widget.challenge!['level'] = selectedLevel;
          widget.challenge!['category'] = selectedCategory;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.challenge == null
                ? "Challenge Published!"
                : "Challenge Edited & Saved!",
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Go back to the list
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are editing or creating for the AppBar title
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
                validator: (value) =>
                    value!.isEmpty ? "Title is required" : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: "Category"),
                      items: categories
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedCategory = val!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedLevel,
                      decoration: const InputDecoration(
                        labelText: "Difficulty Level",
                      ),
                      items: levels
                          .map(
                            (lvl) =>
                                DropdownMenuItem(value: lvl, child: Text(lvl)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => selectedLevel = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Duration (in days)",
                ),
                validator: (value) =>
                    value!.isEmpty ? "Duration is required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Challenge Description",
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                    value!.isEmpty ? "Description is required" : null,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _saveChallenge,
                child: Text(
                  isEditing ? "Save Changes" : "Publish Challenge",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
