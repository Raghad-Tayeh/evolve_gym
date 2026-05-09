import 'package:flutter/material.dart';
import '../../models/challenge_model.dart';
import 'challenge_detail_screen.dart';

class MemberChallengesScreen extends StatefulWidget {
  const MemberChallengesScreen({super.key});

  @override
  State<MemberChallengesScreen> createState() => _MemberChallengesScreenState();
}

class _MemberChallengesScreenState extends State<MemberChallengesScreen> {
  final List<String> tabs = ["All", "My challenges", "New", "Completed"];
  String selectedTab = "All";

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredChallenges = globalChallenges.where((c) {
      if (selectedTab == "All") return true;
      if (selectedTab == "My challenges") return c["status"] == "Active";
      if (selectedTab == "New") return c["status"] == "New";
      if (selectedTab == "Completed") return c["status"] == "Completed";
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Join a Challenge"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(tabs[index]),
                      selected: selectedTab == tabs[index],
                      onSelected: (selected) =>
                          setState(() => selectedTab = tabs[index]),
                      selectedColor: Colors.greenAccent.withValues(alpha: 0.3),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredChallenges.isEmpty
                  ? const Center(child: Text("No challenges found."))
                  : ListView.builder(
                      itemCount: filteredChallenges.length,
                      itemBuilder: (context, index) {
                        return _buildMemberChallengeCard(
                          filteredChallenges[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberChallengeCard(Map<String, dynamic> challenge) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengeDetailScreen(challenge: challenge),
          ),
        ).then((_) => setState(() {}));
      },
      child: Card(
        color: const Color(0xFF1E1E1E),
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(challenge["imageUrl"]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          challenge["level"],
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: Colors.black54,
                      ),
                      Chip(
                        label: Text(
                          challenge["status"],
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.greenAccent,
                          ),
                        ),
                        backgroundColor: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                challenge["category"],
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                challenge["title"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                challenge["description"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    challenge["duration"],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    challenge["status"] == "Active"
                        ? "View Progress >"
                        : "View Details >",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (challenge["status"] == "Active" &&
                  challenge["progress"] != null) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: challenge["progress"],
                  backgroundColor: Colors.grey[800],
                  color: Colors.greenAccent,
                ),
                const SizedBox(height: 4),
                Text(
                  "${(challenge["progress"] * 100).toInt()}%",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
