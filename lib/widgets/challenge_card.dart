// // widgets/challenge_card.dart

// import 'package:evolve_gym/screens/member/dashboard_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/challenge_model.dart';

// class ChallengeCard extends StatelessWidget {
//   final Challenge challenge;
//   final bool isCoach;
//   final VoidCallback onTap;
//   final VoidCallback onPrimaryAction;

//   const ChallengeCard({
//     super.key,
//     required this.challenge,
//     required this.onTap,
//     required this.onPrimaryAction,
//     this.isCoach = false,
//   });

//   Color _difficultyColor() {
//     switch (challenge.difficulty) {
//       case ChallengeDifficulty.beginner:
//         return Colors.greenAccent;
//       case ChallengeDifficulty.intermediate:
//         return Colors.orangeAccent;
//       case ChallengeDifficulty.advanced:
//         return Colors.redAccent;
//     }
//   }

//   String _difficultyLabel() {
//     switch (challenge.difficulty) {
//       case ChallengeDifficulty.beginner:
//         return 'Beginner';
//       case ChallengeDifficulty.intermediate:
//         return 'Intermediate';
//       case ChallengeDifficulty.advanced:
//         return 'Advanced';
//     }
//   }

//   Color _statusColor() {
//     switch (challenge.status) {
//       case ChallengeStatus.newChallenge:
//         return Colors.lightBlueAccent;
//       case ChallengeStatus.active:
//         return Colors.greenAccent;
//       case ChallengeStatus.completed:
//         return Colors.purpleAccent;
//     }
//   }

//   String _statusLabel() {
//     switch (challenge.status) {
//       case ChallengeStatus.newChallenge:
//         return 'New';
//       case ChallengeStatus.active:
//         return 'Active';
//       case ChallengeStatus.completed:
//         return 'Completed';
//     }
//   }

//   String _primaryButtonLabel() {
//     if (isCoach) return 'Edit';
//     switch (challenge.status) {
//       case ChallengeStatus.newChallenge:
//         return 'Join Challenge';
//       case ChallengeStatus.active:
//         return 'View Progress';
//       case ChallengeStatus.completed:
//         return 'View Results';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E1E1E),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.white10),
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Hero image with tags ──────────────────────────────────────
//             Stack(
//               children: [
//                 AspectRatio(
//                   aspectRatio: 16 / 9,
//                   child: Image.network(
//                     challenge.imageUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       color: const Color(0xFF2A2A2A),
//                       child: const Icon(Icons.fitness_center,
//                           color: Colors.white24, size: 40),
//                     ),
//                   ),
//                 ),
//                 // Difficulty tag (top-left)
//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: _Tag(
//                       label: _difficultyLabel(), color: _difficultyColor()),
//                 ),
//                 // Status tag (top-right)
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: _Tag(label: _statusLabel(), color: _statusColor()),
//                 ),
//               ],
//             ),

//             // ── Body ─────────────────────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.all(14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Category
//                   Text(
//                     challenge.category.toUpperCase(),
//                     style: const TextStyle(
//                         color: Colors.white38,
//                         fontSize: 10,
//                         letterSpacing: 1.2),
//                   ),
//                   const SizedBox(height: 4),

//                   // Title
//                   Text(
//                     challenge.title,
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 6),

//                   // Description (2 lines max)
//                   Text(
//                     challenge.description,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                         color: Colors.white54, fontSize: 12, height: 1.4),
//                   ),
//                   const SizedBox(height: 10),

//                   // Meta row
//                   Row(
//                     children: [
//                       _MetaChip(
//                           icon: Icons.calendar_today_outlined,
//                           label: challenge.status == ChallengeStatus.active ||
//                                   challenge.status == ChallengeStatus.completed
//                               ? '${challenge.durationDays} days'
//                               : 'Starts ${DateFormat('MMM d').format(challenge.startDate)}'),
//                       const SizedBox(width: 10),
//                       _MetaChip(
//                           icon: Icons.group_outlined,
//                           label: challenge.participants > 0
//                               ? '${challenge.participants}'
//                               : '0'),
//                     ],
//                   ),

//                   // Progress bar (active only)
//                   if (challenge.status == ChallengeStatus.active) ...[
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text('Progress',
//                             style: TextStyle(
//                                 color: Colors.white54, fontSize: 11)),
//                         Text(
//                           '${(challenge.progress * 100).toStringAsFixed(0)}%',
//                           style: TextStyle(
//                               color: _statusColor(),
//                               fontSize: 11,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: LinearProgressIndicator(
//                         value: challenge.progress,
//                         backgroundColor: Colors.white10,
//                         valueColor: AlwaysStoppedAnimation<Color>(_statusColor()),
//                         minHeight: 5,
//                       ),
//                     ),
//                   ],

//                   // Reward
//                   if (challenge.reward.isNotEmpty) ...[
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         const Icon(Icons.emoji_events_outlined,
//                             color: Colors.amber, size: 13),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             challenge.reward,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 color: Colors.white38, fontSize: 11),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],

//                   const SizedBox(height: 12),

//                   // Primary button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: onPrimaryAction,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: challenge.status ==
//                                 ChallengeStatus.completed
//                             ? Colors.white12
//                             : Colors.greenAccent,
//                         foregroundColor: challenge.status ==
//                                 ChallengeStatus.completed
//                             ? Colors.white70
//                             : Colors.black,
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         elevation: 0,
//                       ),
//                       child: Text(
//                         _primaryButtonLabel(),
//                         style: const TextStyle(
//                             fontSize: 13, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Small reusable widgets ────────────────────────────────────────────────────

// class _Tag extends StatelessWidget {
//   final String label;
//   final Color color;
//   const _Tag({required this.label, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.15),
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(color: color.withOpacity(0.5)),
//       ),
//       child: Text(label,
//           style: TextStyle(
//               color: color, fontSize: 10, fontWeight: FontWeight.w600)),
//     );
//   }
// }

// class _MetaChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _MetaChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, size: 12, color: Colors.white38),
//         const SizedBox(width: 4),
//         Text(label,
//             style: const TextStyle(color: Colors.white38, fontSize: 11)),
//       ],
//     );
//   }
// }
