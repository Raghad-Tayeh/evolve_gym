import 'package:evolve_gym/screens/member/payment_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:evolve_gym/services/supabase_service.dart';
import 'package:flutter/foundation.dart'; // Gives us kIsWeb
import 'package:url_launcher/url_launcher.dart'; // Gives us launchUrl

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // 1. STATE: Keep track of which plan the user has actively selected
  String _selectedPlan = 'Gold';

  // Helper getters to dynamically update the checkout card based on selection
  String get _currentPriceString {
    if (_selectedPlan == 'Basic') return '\$29';
    if (_selectedPlan == 'Platinum') return '\$99';
    return '\$59'; // Default Gold
  }

  int get _currentPriceCents {
    if (_selectedPlan == 'Basic') return 2900;
    if (_selectedPlan == 'Platinum') return 9900;
    return 5900; // Default Gold
  }

  Color get _currentPlanColor {
    if (_selectedPlan == 'Basic') return Colors.grey;
    if (_selectedPlan == 'Platinum') return Colors.lightBlueAccent;
    return Colors.amber; // Default Gold
  }

  IconData get _currentPlanIcon {
    if (_selectedPlan == 'Basic') return Icons.person;
    if (_selectedPlan == 'Platinum') return Icons.diamond;
    return Icons.emoji_events; // Default Gold
  }

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentHistoryScreen(),
                    ),
                  );
                },
                child: const Text(
                  "View Payment History",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
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
                      const Text(
                        "Compare Plans",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          size: 14,
                          color: Colors.orangeAccent,
                        ),
                        label: const Text(
                          "Change Plan",
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPlanCard(
                          "Basic",
                          "\$29",
                          Colors.grey,
                          Icons.person,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPlanCard(
                          "Gold",
                          "\$59",
                          Colors.amber,
                          Icons.emoji_events,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPlanCard(
                          "Platinum",
                          "\$99",
                          Colors.lightBlueAccent,
                          Icons.diamond,
                        ),
                      ),
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
                  const Text(
                    "Checkout Configuration",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  _buildManageMembershipCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. INTERACTIVE CARDS: Wrap the plan card in a GestureDetector to update state
  Widget _buildPlanCard(
    String title,
    String price,
    Color accentColor,
    IconData icon,
  ) {
    final isHighlighted = _selectedPlan == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isHighlighted
              ? const Color(0xFF1E281E)
              : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted
                ? Colors.green.withOpacity(0.5)
                : Colors.transparent,
            width: isHighlighted ? 2 : 1,
          ),
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
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "/mo",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              "Billed monthly",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            _buildFeature("Access to gym floor", true, isHighlighted),
            _buildFeature("Basic equipment access", true, isHighlighted),
            _buildFeature("Locker room access", true, isHighlighted),
            _buildFeature(
              "Group fitness classes",
              title != "Basic",
              isHighlighted,
            ),
            _buildFeature(
              "Personal training sessions",
              title != "Basic",
              isHighlighted,
            ),
            _buildFeature(
              "Nutrition planning",
              title != "Basic",
              isHighlighted,
            ),
            _buildFeature(
              "Premium workout plans",
              title != "Basic",
              isHighlighted,
            ),
            _buildFeature("24/7 gym access", title != "Basic", isHighlighted),
            _buildFeature(
              "Guest passes (2/month)",
              title == "Platinum",
              isHighlighted,
            ),
            _buildFeature(
              "Priority booking",
              title == "Platinum",
              isHighlighted,
            ),
          ],
        ),
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
            color: included
                ? (isHighlighted ? Colors.greenAccent : Colors.grey)
                : Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: included
                    ? (isHighlighted ? Colors.greenAccent : Colors.grey)
                    : Colors.grey.withOpacity(0.5),
                fontSize: 12,
                decoration: included ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. DYNAMIC CHECKOUT: Wire the UI and the Stripe backend to the selected plan
  Widget _buildManageMembershipCard(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _currentPlanColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(_currentPlanIcon, size: 64, color: _currentPlanColor),
          const SizedBox(height: 16),
          Text(
            "$_selectedPlan Membership",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  "Amount",
                  _currentPriceString,
                  "per month",
                  Icons.attach_money,
                  Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoBox(
                  "Status",
                  "Pending",
                  "Awaiting payment",
                  Icons.hourglass_empty,
                  Colors.lightBlueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                      ),
                    ),
                  );

                  // 1. Call Supabase
                  final response = await SupabaseService.client.functions
                      .invoke(
                        'payment-sheet',
                        body: {
                          'amount': _currentPriceCents,
                          'currency': 'usd',
                          'planName': _selectedPlan,
                        },
                      );

                  final data = response.data;

                  // 2. THE PLATFORM SPLIT
                  if (kIsWeb) {
                    // --- WEB BEHAVIOR (Chrome/Edge) ---
                    if (context.mounted) Navigator.pop(context); // close loader

                    final checkoutUrl = data['checkoutUrl'];
                    if (checkoutUrl != null) {
                      await launchUrl(
                        Uri.parse(checkoutUrl),
                        mode: LaunchMode.externalApplication,
                      );

                      // Update DB assuming success (In production, use Stripe Webhooks for this!)
                      await SupabaseService.upgradeMembership(_selectedPlan);
                    }
                  } else {
                    // --- MOBILE BEHAVIOR (iOS/Android) ---
                    final paymentIntent = data['paymentIntent'];

                    await Stripe.instance.initPaymentSheet(
                      paymentSheetParameters: SetupPaymentSheetParameters(
                        paymentIntentClientSecret: paymentIntent,
                        merchantDisplayName: 'Evolve Gym',
                        style: ThemeMode.dark,
                      ),
                    );

                    if (context.mounted) Navigator.pop(context); // close loader

                    await Stripe.instance.presentPaymentSheet();

                    // Update DB on successful sheet closure
                    final dbSuccess = await SupabaseService.upgradeMembership(
                      _selectedPlan,
                      paymentIntentId:
                          data['paymentIntent'], // token we got from the Edge Function!
                    );

                    if (context.mounted) {
                      if (dbSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Success! You are now on the $_selectedPlan plan.",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  }
                } catch (e) {
                  if (context.mounted && Navigator.canPop(context))
                    Navigator.pop(context);
                  print("Payment Error: $e");
                }
              },
              icon: const Icon(
                Icons.shopping_cart_checkout,
                color: Colors.white,
                size: 18,
              ),
              label: Text(
                "Purchase $_selectedPlan Plan",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
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
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: title == "Amount" ? Colors.greenAccent : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
