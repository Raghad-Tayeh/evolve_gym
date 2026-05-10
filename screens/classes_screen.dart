import 'package:flutter/material.dart';
import 'class_details_screen.dart';

List<Map<String, String>> globalClasses = [
  {
    "title": "Morning HIIT Blast",
    "tag": "HIIT",
    "level": "Advanced",
    "duration": "45 min",
    "spots": "12 spots left",
    "time": "Morning",
  },
  {
    "title": "Strength & Conditioning",
    "tag": "Strength",
    "level": "Beginner",
    "duration": "60 min",
    "spots": "5 spots left",
    "time": "Afternoon",
  },
  {
    "title": "Power Yoga",
    "tag": "Yoga",
    "level": "Intermediate",
    "duration": "50 min",
    "spots": "8 spots left",
    "time": "Evening",
  },
];

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
    List<Map<String, String>> filteredClasses = globalClasses.where((gymClass) {
      bool matchesTag =
          selectedTag == "All" ||
          gymClass["tag"] == selectedTag ||
          gymClass["level"] == selectedTag;
      bool matchesTime =
          selectedTime == null || gymClass["time"] == selectedTime;
      bool matchesSearch = gymClass["title"]!.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesTag && matchesTime && matchesSearch;
    }).toList();

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
              child: filteredClasses.isEmpty
                  ? const Center(child: Text("No classes found."))
                  : ListView.builder(
                      itemCount: filteredClasses.length,
                      itemBuilder: (context, index) {
                        final gymClass = filteredClasses[index];
                        return _buildClassCard(
                          gymClass["title"]!,
                          gymClass["tag"]!,
                          gymClass["level"]!,
                          gymClass["duration"]!,
                          gymClass["spots"]!,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(
    String title,
    String tag,
    String level,
    String duration,
    String spots,
  ) {
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
