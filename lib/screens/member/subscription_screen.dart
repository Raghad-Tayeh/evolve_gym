import 'package:evolve_gym/screens/member/payment_history_screen.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Manage Subscription"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.greenAccent, Colors.teal],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  // Navigate to Payment History
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentHistoryScreen()));
                },
                child: const Text(
                  "View Payment History",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Compare Plans
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Compare Plans", style: TextStyle(color: Colors.grey, fontSize: 16)),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 14, color: Colors.orangeAccent),
                        label: const Text("Change Plan", style: TextStyle(color: Colors.orangeAccent)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildPlanCard("Basic", "\$29", Colors.grey, Icons.person, false)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildPlanCard("Gold", "\$59", Colors.amber, Icons.emoji_events, true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildPlanCard("Platinum", "\$99", Colors.lightBlueAccent, Icons.diamond, false)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            // Right Side: Current Membership Management
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Manage your membership", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildManageMembershipCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(String title, String price, Color accentColor, IconData icon, bool isHighlighted) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFF1E281E) : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isHighlighted ? Colors.green.withOpacity(0.3) : Colors.transparent),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: accentColor),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: accentColor, fontSize: 20)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const Text("/mo", style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          const Text("Billed monthly", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 24),
          _buildFeature("Access to gym floor", true, isHighlighted),
          _buildFeature("Basic equipment access", true, isHighlighted),
          _buildFeature("Locker room access", true, isHighlighted),
          _buildFeature("Group fitness classes", title != "Basic", isHighlighted),
          _buildFeature("Personal training sessions", title != "Basic", isHighlighted),
          _buildFeature("Nutrition planning", title != "Basic", isHighlighted),
          _buildFeature("Premium workout plans", title != "Basic", isHighlighted),
          _buildFeature("24/7 gym access", title != "Basic", isHighlighted),
          _buildFeature("Guest passes (2/month)", title == "Platinum", isHighlighted),
          _buildFeature("Priority booking", title == "Platinum", isHighlighted),
        ],
      ),
    );
  }

  Widget _buildFeature(String text, bool included, bool isHighlighted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            included ? Icons.check : Icons.close,
            size: 16,
            color: included ? (isHighlighted ? Colors.greenAccent : Colors.grey) : Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: included ? (isHighlighted ? Colors.greenAccent : Colors.grey) : Colors.grey.withOpacity(0.5),
                fontSize: 12,
                decoration: included ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageMembershipCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
          const SizedBox(height: 16),
          const Text("Gold Membership", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildInfoBox("Amount", "\$59", "per month", Icons.attach_money, Colors.greenAccent)),
              const SizedBox(width: 12),
              Expanded(child: _buildInfoBox("Renewal", "Dec 1", "31 days left", Icons.calendar_today, Colors.lightBlueAccent)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildInfoBox("Billing", "Monthly", "Auto-renew ON", Icons.autorenew, Colors.purpleAccent)),
              const SizedBox(width: 12),
              Expanded(child: _buildInfoBox("Member Since", "Nov 2024", "13 months", Icons.person_add, Colors.orangeAccent)),
            ],
          ),
          const SizedBox(height: 32),
          _buildActionButton("Renew Now", Icons.refresh, Colors.white),
          const SizedBox(height: 12),
          _buildActionButton("Cancel Membership", Icons.block, Colors.redAccent, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String title, String value, String subtitle, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: title == "Amount" ? Colors.greenAccent : Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, {bool isDestructive = false}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: isDestructive ? Colors.redAccent.withOpacity(0.5) : Colors.white24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {},
        icon: Icon(icon, color: color, size: 18),
        label: Text(text, style: TextStyle(color: color)),
      ),
    );
  }
}