import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
            scrollDirection: Axis.horizontal, // Added to prevent cramping with the new column
            child: SingleChildScrollView(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: SupabaseService.getPaymentHistoryStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(48.0),
                      child: Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
                    );
                  }

                  final history = snapshot.data ?? [];
                  final reversedHistory = history.reversed.toList();

                  if (reversedHistory.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(48.0),
                      child: Center(
                        child: Text(
                          "No payment history found.", 
                          style: TextStyle(color: Colors.grey, fontSize: 16)
                        ),
                      ),
                    );
                  }

                  return DataTable(
                    headingTextStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Plan')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Expires')), // NEW COLUMN HEADER
                      DataColumn(label: Text('Invoice')),
                    ],
                    rows: reversedHistory.map((record) {
                      
                      // 1. Format Purchase Date
                      final dateStr = record['created_at'] ?? '';
                      String displayDate = 'Unknown';
                      if (dateStr.isNotEmpty) {
                        final parsed = DateTime.parse(dateStr).toLocal();
                        displayDate = "${parsed.month}/${parsed.day}/${parsed.year}";
                      }

                      // 2. Format Expiration Date
                      final expiresStr = record['expires_at'] ?? '';
                      String displayExpires = 'N/A';
                      if (expiresStr.isNotEmpty) {
                        final parsedExp = DateTime.parse(expiresStr).toLocal();
                        displayExpires = "${parsedExp.month}/${parsedExp.day}/${parsedExp.year}";
                      }

                      return _buildHistoryRow(
                        displayDate,
                        record['description'] ?? 'Membership Charge',
                        record['plan_name'] ?? 'Unknown',
                        '\$${record['amount']}',
                        displayExpires, // Pass it down!
                        record['receipt_url'], 
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Updated signature to accept the 'expires' string
  DataRow _buildHistoryRow(String date, String desc, String plan, String amount, String expires, String? receiptUrl) {
    return DataRow(
      cells: [
        DataCell(Text(date, style: const TextStyle(color: Colors.white))),
        DataCell(Text(desc, style: const TextStyle(color: Colors.white70))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: plan == 'Gold' ? Colors.amber.withOpacity(0.2) 
                   : plan == 'Platinum' ? Colors.lightBlueAccent.withOpacity(0.2) 
                   : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              plan,
              style: TextStyle(
                color: plan == 'Gold' ? Colors.amber 
                     : plan == 'Platinum' ? Colors.lightBlueAccent 
                     : Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(Text(amount, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))),
        
        // NEW EXPIRES CELL
        DataCell(Text(expires, style: const TextStyle(color: Colors.orangeAccent))),

        DataCell(
          receiptUrl != null && receiptUrl.isNotEmpty 
          ? TextButton.icon(
              onPressed: () async {
                final uri = Uri.parse(receiptUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.download_rounded, size: 16, color: Colors.blueAccent),
              label: const Text("PDF", style: TextStyle(color: Colors.blueAccent)),
            )
          : const Text("Processing...", style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
        ),
      ],
    );
  }
}