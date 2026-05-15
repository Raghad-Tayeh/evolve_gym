import 'package:flutter/material.dart';

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
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID', style: TextStyle(color: Colors.grey))),
                  DataColumn(label: Text('Name', style: TextStyle(color: Colors.grey))),
                  DataColumn(label: Text('Role', style: TextStyle(color: Colors.grey))),
                  DataColumn(label: Text('Actions', style: TextStyle(color: Colors.grey))),
                ],
                rows: [
                  _buildUserRow('001', 'Sarah Jenkins', 'Member'),
                  _buildUserRow('002', 'Marcus Rodriguez', 'Trainer'),
                  _buildUserRow('003', 'Admin User', 'Admin'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildUserRow(String id, String name, String currentRole) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(color: Colors.white))),
        DataCell(Text(name, style: const TextStyle(color: Colors.white))),
        DataCell(
          DropdownButton<String>(
            value: currentRole,
            dropdownColor: const Color(0xFF2C2C2C),
            style: const TextStyle(color: Colors.greenAccent),
            underline: const SizedBox(),
            items: <String>['Member', 'Trainer', 'Admin'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Handle role change logic in database
            },
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                onPressed: () { /* Delete User logic */ },
              ),
            ],
          ),
        ),
      ],
    );
  }
}