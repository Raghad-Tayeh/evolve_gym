import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart';

class SystemUsageView extends StatelessWidget {
  const SystemUsageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "System Overview",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 24),
        
        // Use FutureBuilder to call your getSystemStats function
        FutureBuilder<Map<String, int>>(
          future: SupabaseService.getSystemStats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
            }
            
            // Provide fallback data if it fails
            final stats = snapshot.data ?? {'totalUsers': 0, 'activeSubs': 0, 'classesThisWeek': 0};

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("Total Users", stats['totalUsers'].toString(), Icons.people, Colors.blueAccent),
                _buildStatCard("Active Subscriptions", stats['activeSubs'].toString(), Icons.verified, Colors.greenAccent),
                _buildStatCard("Classes This Week", stats['classesThisWeek'].toString(), Icons.event_available, Colors.orangeAccent),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}