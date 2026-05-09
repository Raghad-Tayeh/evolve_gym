# Add this dependency to your pubspec.yaml:
#
# dependencies:
#   flutter:
#     sdk: flutter
#   intl: ^0.19.0          # for DateFormat
#
# Then run: flutter pub get

# ──────────────────────────────────────────────────────────────────────────────
# FILE STRUCTURE
# ──────────────────────────────────────────────────────────────────────────────
#
# lib/
# ├── main.dart                                  ← Demo entry (role switcher)
# ├── models/
# │   └── challenge_model.dart                   ← Data models + dummy data
# ├── widgets/
# │   └── challenge_card.dart                    ← Shared card widget (member)
# └── screens/
#     ├── member/
#     │   ├── member_challenges_screen.dart       ← "Join a Challenge" list
#     │   └── challenge_detail_screen.dart        ← Detail view (member + coach)
#     └── coach/
#         ├── coach_challenges_screen.dart        ← "Manage Challenges" list
#         └── create_challenge_screen.dart        ← Create challenge form
#
# ──────────────────────────────────────────────────────────────────────────────
# HOW TO WIRE INTO YOUR EXISTING APP
# ──────────────────────────────────────────────────────────────────────────────
#
# Member navigation:
#   Navigator.push(context, MaterialPageRoute(
#     builder: (_) => const MemberChallengesScreen(),
#   ));
#
# Coach navigation:
#   Navigator.push(context, MaterialPageRoute(
#     builder: (_) => const CoachChallengesScreen(),
#   ));
#
# Remove main.dart and _RoleSwitcher — they are for demo only.
