import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Payment History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: DataTable(
              headingTextStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Plan')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Invoice')),
              ],
              rows: [
                _buildHistoryRow('Nov 1, 2024', 'Monthly Subscription Auto-Renew', 'Gold', '\$59.00'),
                _buildHistoryRow('Oct 1, 2024', 'Monthly Subscription Auto-Renew', 'Gold', '\$59.00'),
                _buildHistoryRow('Sep 1, 2024', 'Plan Upgrade (Prorated)', 'Gold', '\$30.00'),
                _buildHistoryRow('Aug 1, 2024', 'Monthly Subscription Auto-Renew', 'Basic', '\$29.00'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildHistoryRow(String date, String desc, String plan, String amount) {
    return DataRow(
      cells: [
        DataCell(Text(date, style: const TextStyle(color: Colors.white))),
        DataCell(Text(desc, style: const TextStyle(color: Colors.white70))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: plan == 'Gold' ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              plan,
              style: TextStyle(
                color: plan == 'Gold' ? Colors.amber : Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(Text(amount, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))),
        DataCell(
          TextButton.icon(
            onPressed: () { /* Download logic */ },
            icon: const Icon(Icons.download_rounded, size: 16, color: Colors.blueAccent),
            label: const Text("PDF", style: TextStyle(color: Colors.blueAccent)),
          ),
        ),
      ],
    );
  }
}