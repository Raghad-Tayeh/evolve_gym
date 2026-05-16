import 'package:flutter/material.dart';
import 'package:evolve_gym/services/supabase_service.dart';

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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Custom plan creation coming soon!")),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Create Custom Plan"),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: SupabaseService.getPaymentPlansStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
              }

              final plans = snapshot.data ?? [];

              if (plans.isEmpty) {
                return const Center(child: Text("No plans found in database.", style: TextStyle(color: Colors.grey)));
              }

              return Row(
                children: plans.map((plan) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: AdminEditCard(plan: plan), // Our custom widget below
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── CUSTOM STATEFUL WIDGET FOR THE CARDS ────────────────────────────────

class AdminEditCard extends StatefulWidget {
  final Map<String, dynamic> plan;

  const AdminEditCard({super.key, required this.plan});

  @override
  State<AdminEditCard> createState() => _AdminEditCardState();
}

class _AdminEditCardState extends State<AdminEditCard> {
  late TextEditingController _priceController;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the inputs with the data straight from the database
    _priceController = TextEditingController(text: widget.plan['price'].toString());
    _isActive = widget.plan['is_active'] ?? true;
  }

  @override
  void didUpdateWidget(AdminEditCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the database updates externally, refresh our local state
    if (oldWidget.plan != widget.plan) {
      _priceController.text = widget.plan['price'].toString();
      _isActive = widget.plan['is_active'] ?? true;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);

    // Parse the text field into a double (fallback to 0.0 if they typed letters by accident)
    final newPrice = double.tryParse(_priceController.text) ?? 0.0;

    final success = await SupabaseService.updatePaymentPlan(widget.plan['id'], newPrice, _isActive);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.plan['name']} updated!"), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update plan."), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                widget.plan['name'],
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Switch(
                value: _isActive,
                onChanged: (bool value) {
                  setState(() => _isActive = value);
                },
                activeColor: Colors.greenAccent,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text("Monthly Price (\$)", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              onPressed: _isLoading ? null : _handleSave,
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent))
                  : const Text("Save Changes", style: TextStyle(color: Colors.blueAccent)),
            ),
          ),
        ],
      ),
    );
  }
}