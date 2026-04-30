import 'package:flutter/material.dart';
import 'classes_screen.dart';

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({super.key});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String selectedTag = 'HIIT';
  String selectedLevel = 'Beginner';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> tags = ['HIIT', 'Yoga', 'Strength', 'Cardio'];
  final List<String> levels = ['Beginner', 'Intermediate', 'Advanced'];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  void _saveClass() {
    if (selectedTime == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select a time."),
        ),
      );
      return;
    }

    String timeCategory = "Morning";
    if (selectedTime!.hour >= 12 && selectedTime!.hour < 17) {
      timeCategory = "Afternoon";
    } else if (selectedTime!.hour >= 17) {
      timeCategory = "Evening";
    }

    globalClasses.add({
      "title": _titleController.text,
      "tag": selectedTag,
      "level": selectedLevel,
      "duration": "${_durationController.text} min",
      "spots": "15 spots left",
      "time": timeCategory,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Class Created & Synced to Schedule!"),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Class")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Class Title (e.g. Morning Spin)",
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedTag, // FIXED
                      decoration: const InputDecoration(
                        labelText: "Category Tag",
                      ),
                      items: tags
                          .map(
                            (tag) =>
                                DropdownMenuItem(value: tag, child: Text(tag)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => selectedTag = val!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedLevel, // FIXED
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: InputDecoration(
                        labelText: "Date",
                        hintText: selectedDate == null
                            ? "Select Date"
                            : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: _pickTime,
                      decoration: InputDecoration(
                        labelText: "Time",
                        hintText: selectedTime == null
                            ? "Select Time"
                            : selectedTime!.format(context),
                        suffixIcon: const Icon(Icons.access_time),
                      ),
                    ),
                  ),
                ],
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
                child: const Text(
                  "Save & Publish Class",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
