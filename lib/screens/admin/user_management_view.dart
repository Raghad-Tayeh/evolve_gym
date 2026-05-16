import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart';

class UserManagementView extends StatelessWidget {
  const UserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "User Management",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              // NEW: StreamBuilder listens to the profiles table
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: SupabaseService.getAllUsersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
                    );
                  }

                  final users = snapshot.data ?? [];

                  return DataTable(
                    columns: const [
                      DataColumn(label: Text('Name', style: TextStyle(color: Colors.grey))),
                      DataColumn(label: Text('Role', style: TextStyle(color: Colors.grey))),
                      DataColumn(label: Text('Actions', style: TextStyle(color: Colors.grey))),
                    ],
                    rows: users.map((user) {
                      return _buildUserRow(context, user['id'], user['full_name'] ?? 'Unknown', user['role']);
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildUserRow(BuildContext context, String id, String name, String currentRole) {
    return DataRow(
      cells: [
        DataCell(Text(name, style: const TextStyle(color: Colors.white))),
        DataCell(
          DropdownButton<String>(
            value: currentRole, // Expects 'member', 'coach', or 'admin' exactly as saved in the DB
            dropdownColor: const Color(0xFF2C2C2C),
            style: const TextStyle(color: Colors.greenAccent),
            underline: const SizedBox(),
            // Map over the exact lowercase strings required by the database
            items: <String>['member', 'coach', 'admin'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                // Capitalize the first letter for the UI display
                child: Text(value[0].toUpperCase() + value.substring(1)),
              );
            }).toList(),
            onChanged: (String? newValue) async {
              if (newValue != null) {
                // Call DB update
                await SupabaseService.updateUserRole(id, newValue);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$name is now a $newValue"), backgroundColor: Colors.green),
                  );
                }
              }
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
            onPressed: () async {
              // Delete user logic
              final success = await SupabaseService.deleteUserProfile(id);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile deleted."), backgroundColor: Colors.orange),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}