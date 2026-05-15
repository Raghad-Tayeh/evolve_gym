import 'package:flutter/material.dart';

class PaymentPlansView extends StatelessWidget {
  const PaymentPlansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Manage Payment Plans",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
              onPressed: () { /* Add new plan */ },
              icon: const Icon(Icons.add),
              label: const Text("Create Custom Plan"),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildAdminEditCard("Basic", "29", true)),
              const SizedBox(width: 16),
              Expanded(child: _buildAdminEditCard("Gold", "59", true)),
              const SizedBox(width: 16),
              Expanded(child: _buildAdminEditCard("Platinum", "99", true)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminEditCard(String title, String currentPrice, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Switch(
                value: isActive,
                onChanged: (bool value) { /* Toggle active status */ },
                activeColor: Colors.greenAccent,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text("Monthly Price (\$)", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: currentPrice,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.attach_money, color: Colors.grey),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.blueAccent),
              ),
              onPressed: () { /* Update DB logic */ },
              child: const Text("Save Changes", style: TextStyle(color: Colors.blueAccent)),
            ),
          ),
        ],
      ),
    );
  }
}