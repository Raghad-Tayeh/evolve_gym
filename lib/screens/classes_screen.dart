import 'package:evolve_gym/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'class_details_screen.dart';

class ClassesScreen extends StatefulWidget {
  final bool isCoach;
  const ClassesScreen({super.key, this.isCoach = false});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final List<String> tags = [
    "All",
    "Beginner",
    "Intermediate",
    "Advanced",
    "HIIT",
    "Yoga",
    "Strength",
  ];
  String selectedTag = "All";
  final List<String> times = ["Morning", "Afternoon", "Evening"];
  String? selectedTime;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCoach ? "My Schedule" : "Find Your Next Class"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: const InputDecoration(
                      hintText: "Search classes...",
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.black26,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedTime,
                  hint: const Text("Time"),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("All Times"),
                    ),
                    ...times.map(
                      (time) =>
                          DropdownMenuItem(value: time, child: Text(time)),
                    ),
                  ],
                  onChanged: (val) => setState(() => selectedTime = val),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(tags[index]),
                      selected: selectedTag == tags[index],
                      onSelected: (bool selected) =>
                          setState(() => selectedTag = tags[index]),
                      selectedColor: Colors.greenAccent.withValues(
                        alpha: 0.3,
                      ), // FIXED
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              // NEW: StreamBuilder replaces the hardcoded list
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: SupabaseService.getClassesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No classes scheduled yet."),
                    );
                  }

                  final classes = snapshot.data!;

                  // Apply your search/filter logic to the stream data
                  final filteredClasses = classes.where((gymClass) {
                    bool matchesTag =
                        selectedTag == "All" ||
                        gymClass["category"] == selectedTag ||
                        gymClass["difficulty_level"] == selectedTag;
                    bool matchesSearch = gymClass["title"]
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                    return matchesTag && matchesSearch;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredClasses.length,
                    itemBuilder: (context, index) {
                      final gymClass = filteredClasses[index];
                      // Calculate duration for display
                      final start = DateTime.parse(gymClass['start_time']);
                      final end = DateTime.parse(gymClass['end_time']);
                      final durationMins = end.difference(start).inMinutes;

                      return _buildClassCard(
                        classId: gymClass['id']
                            .toString(), // Added .toString() for safety
                        title: gymClass["title"] ?? "Unknown",
                        tag: gymClass["category"] ?? "Unknown",
                        level: gymClass["difficulty_level"] ?? "Beginner",
                        duration: "$durationMins min",
                        spots: "${gymClass['capacity']} spots",
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard({
    required String classId,
    required String title,
    required String tag,
    required String level,
    required String duration,
    required String spots,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=1470&auto=format&fit=crop",
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ), // FIXED
                  child: Text(
                    level,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "$duration • $spots",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isCoach
                ? Colors.white24
                : Colors.greenAccent,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassDetailsScreen(
                  classId: classId,
                  title: title,
                  tag: tag,
                  duration: duration,
                  isCoach: widget.isCoach,
                ),
              ),
            );
          },
          child: Text(
            widget.isCoach ? "View" : "Book",
            style: TextStyle(
              color: widget.isCoach ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
