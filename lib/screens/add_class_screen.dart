import 'package:evolve_gym/services/supabase_service.dart';
import 'package:flutter/material.dart';

class AddClassScreen extends StatefulWidget {
  final String? classId; 
  const AddClassScreen({super.key, this.classId});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController(); // NEW

  String selectedTag = 'HIIT';
  String selectedLevel = 'Beginner';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool _isLoading = false;

  final List<String> tags = ['HIIT', 'Yoga', 'Strength', 'Cardio'];
  final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();
    // Default image placeholder in case they create a completely fresh class
    _imageUrlController.text = "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80";
    
    if (widget.classId != null) {
      _loadExistingClass();
    }
  }

  Future<void> _loadExistingClass() async {
    setState(() => _isLoading = true);
    final gymClass = await SupabaseService.getClassById(widget.classId!);
    
    if (gymClass != null && mounted) {
      setState(() {
        _titleController.text = gymClass['title'];
        selectedTag = gymClass['category'] ?? 'HIIT';
        selectedLevel = gymClass['difficulty_level'] ?? 'Beginner';
        _imageUrlController.text = gymClass['image_url'] ?? "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80";
        
        final start = DateTime.parse(gymClass['start_time']).toLocal();
        final end = DateTime.parse(gymClass['end_time']).toLocal();
        selectedDate = start;
        selectedTime = TimeOfDay.fromDateTime(start);
        _durationController.text = end.difference(start).inMinutes.toString();
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Future<void> _saveClass() async {
    if (selectedDate == null || selectedTime == null || _titleController.text.isEmpty || _durationController.text.isEmpty || _imageUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and select date/time.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final startTime = DateTime(
      selectedDate!.year, selectedDate!.month, selectedDate!.day,
      selectedTime!.hour, selectedTime!.minute,
    );

    int duration = int.tryParse(_durationController.text) ?? 60;
    final imageUrl = _imageUrlController.text.trim();
    bool success;

    if (widget.classId == null) {
      success = await SupabaseService.createClass(
        title: _titleController.text, tag: selectedTag,
        level: selectedLevel, startTime: startTime, durationMins: duration,
        imageUrl: imageUrl, // Pass Image
      );
    } else {
      success = await SupabaseService.updateClass(
        classId: widget.classId!, title: _titleController.text, tag: selectedTag,
        level: selectedLevel, startTime: startTime, durationMins: duration,
        imageUrl: imageUrl, // Pass Image
      );
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.classId == null ? "Class Created!" : "Class Updated!"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.classId == null ? "Add New Class" : "Edit Class")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Class Title (e.g. Morning Spin)"),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedTag,
                          decoration: const InputDecoration(labelText: "Category Tag"),
                          items: tags.map((tag) => DropdownMenuItem(value: tag, child: Text(tag))).toList(),
                          onChanged: (val) => setState(() => selectedTag = val!),
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true, onTap: _pickDate,
                          decoration: InputDecoration(
                            labelText: "Date",
                            hintText: selectedDate == null ? "Select Date" : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          readOnly: true, onTap: _pickTime,
                          decoration: InputDecoration(
                            labelText: "Time",
                            hintText: selectedTime == null ? "Select Time" : selectedTime!.format(context),
                            suffixIcon: const Icon(Icons.access_time),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // NEW: Class Image URL input field
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: "Class Image URL",
                      hintText: "Paste an image link from Unsplash",
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Duration (mins)"),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _saveClass,
                    child: Text(
                      widget.classId == null ? "Save & Publish Class" : "Save Changes",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}