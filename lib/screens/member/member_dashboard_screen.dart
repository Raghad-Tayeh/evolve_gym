import 'package:evolve_gym/screens/member/subscription_screen.dart';
import 'package:evolve_gym/screens/member/notifications_screen.dart';
import 'package:evolve_gym/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:evolve_gym/appcolors.dart';

// ---- Data Models ------
class ClassItem {
  final String day;
  final int date;
  final String name;
  final String instructor;
  final String time;
  final Color color;

  const ClassItem({
    required this.day,
    required this.date,
    required this.name,
    required this.instructor,
    required this.time,
    required this.color,
  });
}

class WorkoutDay {
  final String day;
  final String dateLabel;
  final String workoutName;
  final String time;
  final String duration;
  final String emoji;
  final Color accentColor;
  final bool isRest;

  const WorkoutDay({
    required this.day,
    required this.dateLabel,
    required this.workoutName,
    required this.time,
    required this.duration,
    required this.emoji,
    required this.accentColor,
    this.isRest = false,
  });
}

class Challenge {
  final String title;
  final String reward;
  final int current;
  final int total;
  final int daysLeft;
  final Color tagColor;

  const Challenge({
    required this.title,
    required this.reward,
    required this.current,
    required this.total,
    required this.daysLeft,
    required this.tagColor,
  });
}

// ---- Sample Data (Only Workouts remain static for the editable planner) ------
final List<WorkoutDay> workouts = [
  WorkoutDay(
    day: 'Monday',
    dateLabel: 'Nov 3',
    workoutName: 'Chest Day',
    time: '07:00 AM',
    duration: '1 hour',
    emoji: '💪',
    accentColor: AppColors.chestGreen,
  ),
  WorkoutDay(
    day: 'Tuesday',
    dateLabel: 'Nov 4',
    workoutName: 'Back Day',
    time: '07:00 AM',
    duration: '1 hour',
    emoji: '🏋️',
    accentColor: AppColors.backTeal,
  ),
  WorkoutDay(
    day: 'Wednesday',
    dateLabel: 'Nov 5',
    workoutName: 'Leg Day',
    time: '07:00 AM',
    duration: '1.5 hours',
    emoji: '🦵',
    accentColor: AppColors.legOrange,
  ),
  WorkoutDay(
    day: 'Thursday',
    dateLabel: 'Nov 6',
    workoutName: 'Cardio',
    time: '06:00 AM',
    duration: '45 min',
    emoji: '🏃',
    accentColor: AppColors.cardioPurple,
  ),
  WorkoutDay(
    day: 'Friday',
    dateLabel: 'Nov 7',
    workoutName: 'Arms Day',
    time: '07:00 AM',
    duration: '1.5 hours',
    emoji: '💪',
    accentColor: AppColors.armsRed,
  ),
  WorkoutDay(
    day: 'Saturday',
    dateLabel: 'Nov 8',
    workoutName: 'HIIT',
    time: '08:00 AM',
    duration: '1.5 hours',
    emoji: '⚡',
    accentColor: AppColors.hiitYellow,
  ),
  WorkoutDay(
    day: 'Sunday',
    dateLabel: 'Nov 9',
    workoutName: 'Rest Day',
    time: '',
    duration: '',
    emoji: '😴',
    accentColor: AppColors.textSecondary,
    isRest: true,
  ),
];

// ---- Member Dashboard ------
class MemberDashboardScreen extends StatefulWidget {
  const MemberDashboardScreen({super.key});

  @override
  State<MemberDashboardScreen> createState() => _MemberDashboardScreenState();
}

class _MemberDashboardScreenState extends State<MemberDashboardScreen> {
  final List<WorkoutDay> _workouts = List.from(workouts);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 10),
        _buildMainContent(),
      ],
    );
  }

  // ── Database-Connected Header ──────────────────────────────────────────
  Widget _buildHeader() {
    return StreamBuilder<Map<String, dynamic>>(
      stream: SupabaseService.getCurrentUserProfileStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
          );
        }

        final profile = snapshot.data ?? {};
        final fullName = profile['full_name'] ?? 'User';
        final firstName = fullName.split(' ').first; 
        
        final planName = profile['subscription_plan'] ?? 'No Plan';
        final status = profile['subscription_status'] ?? 'Inactive';
        final isActive = status == 'Active';
        
        final memberId = profile['id']?.toString().substring(0, 8).toUpperCase() ?? '00000000';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Welcome back, $firstName ',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Text('👋', style: TextStyle(fontSize: 22)),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    _headerStat(
                      'Membership ID',
                      memberId,
                      valueColor: AppColors.gold,
                      icon: Icons.verified_rounded,
                    ),
                    _divider(),
                    _headerStatBadge(planName, isActive: isActive),
                    _divider(),
                    _headerStat('Coach name', 'Marcus R.'), 
                    _divider(),
                    _headerProgress(),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context, ) => const SubscriptionScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit_rounded,
                        size: 14,
                        color: AppColors.gold,
                      ),
                      label: const Text(
                        'Manage Subscription',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _headerStat(
    String label,
    String value, {
    Color? valueColor,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(icon, color: AppColors.gold, size: 13),
            ],
          ],
        ),
      ],
    );
  }

  Widget _headerStatBadge(String label, {bool isActive = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.accent.withOpacity(0.2)
                : AppColors.textSecondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            isActive ? 'ACTIVE' : 'DISABLED',
            style: TextStyle(
              color: isActive ? AppColors.accent : AppColors.armsRed,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress of goals achieved',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 120,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.70,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.backTeal, AppColors.accent],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '70%',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.border,
    );
  }

  Widget _buildMainContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        SizedBox(width: 260, child: _buildWeeklyClassSchedule()),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWorkoutSchedule(),
              const SizedBox(height: 24),
              _buildMonthlyChallenge(),
            ],
          ),
        ),
      ],
    );
  }

  // ── Database-Connected Weekly Class Schedule ──────────────────────────────
  Widget _buildWeeklyClassSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your booked classes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        
        FutureBuilder<List<Map<String, dynamic>>>(
          future: SupabaseService.getMyBookedClasses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.greenAccent));
            }

            final bookedClasses = snapshot.data ?? [];

            if (bookedClasses.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  "You haven't booked any classes yet. Head to the schedule to find your next workout!",
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
              );
            }

            return Column(
              children: bookedClasses.map((gymClass) {
                final start = DateTime.parse(gymClass['start_time']);
                final end = DateTime.parse(gymClass['end_time']);
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final dayString = days[start.weekday - 1];
                
                String formatTime(DateTime t) {
                  int h = t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour);
                  String ampm = t.hour >= 12 ? 'PM' : 'AM';
                  String m = t.minute.toString().padLeft(2, '0');
                  return "$h:$m $ampm";
                }

                Color tagColor = AppColors.chestGreen;
                if (gymClass['category'] == 'Yoga') tagColor = AppColors.cardioPurple;
                if (gymClass['category'] == 'HIIT') tagColor = AppColors.hiitYellow;
                if (gymClass['category'] == 'Strength') tagColor = AppColors.legOrange;

                return _buildClassCard(ClassItem(
                  day: dayString,
                  date: start.day,
                  name: gymClass['title'] ?? 'Gym Session',
                  instructor: "Gym Coach",
                  time: "${formatTime(start)} - ${formatTime(end)}",
                  color: tagColor,
                ));
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildClassCard(ClassItem c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 48,
            decoration: BoxDecoration(
              color: c.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  c.day,
                  style: TextStyle(
                    color: c.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${c.date}',
                  style: TextStyle(
                    color: c.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.textSecondary,
                      size: 12,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        c.instructor,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.textSecondary,
                      size: 12,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      c.time,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Workout Schedule ──────────────────────────────────────────────────────
  Widget _buildWorkoutSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Weekly Workout Schedule',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Click workouts to edit details',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _workouts.length,
            itemBuilder: (context, index) {
              final w = _workouts[index];
              return GestureDetector(
                onTap: () => _showEditDialog(context, index),
                child: _buildWorkoutCard(w, index),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    final workoutTypes = [
      WorkoutDay(
        day: _workouts[index].day,
        dateLabel: _workouts[index].dateLabel,
        workoutName: 'Chest Day',
        time: '07:00 AM',
        duration: '1 hour',
        emoji: '💪',
        accentColor: AppColors.chestGreen,
      ),
      WorkoutDay(
        day: _workouts[index].day,
        dateLabel: _workouts[index].dateLabel,
        workoutName: 'Back Day',
        time: '07:00 AM',
        duration: '1 hour',
        emoji: '🏋️',
        accentColor: AppColors.backTeal,
      ),
      WorkoutDay(
        day: _workouts[index].day,
        dateLabel: _workouts[index].dateLabel,
        workoutName: 'Leg Day',
        time: '07:00 AM',
        duration: '1.5 hours',
        emoji: '🦵',
        accentColor: AppColors.legOrange,
      ),
      WorkoutDay(
        day: _workouts[index].day,
        dateLabel: _workouts[index].dateLabel,
        workoutName: 'Cardio',
        time: '06:00 AM',
        duration: '45 min',
        emoji: '🏃',
        accentColor: AppColors.cardioPurple,
      ),
      WorkoutDay(
        day: _workouts[index].day,
        dateLabel: _workouts[index].dateLabel,
        workoutName: 'Arms Day',
        time: '07:00 AM',
        duration: '1.5 hours',
        emoji: '💪',
        accentColor: AppColors.armsRed,
      ),
      WorkoutDay(
        day: _workouts[index].day,
        dateLabel: _workouts[index].dateLabel,
        workoutName: 'HIIT',
        time: '08:00 AM',
        duration: '1.5 hours',
        emoji: '⚡',
        accentColor: AppColors.hiitYellow,
      ),
      WorkoutDay(
        day: _workouts[index].day,
        dateLabel: _workouts[index].dateLabel,
        workoutName: 'Rest Day',
        time: '',
        duration: '',
        emoji: '😴',
        accentColor: AppColors.textSecondary,
        isRest: true,
      ),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit ${_workouts[index].day}',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: workoutTypes.map((type) {
              final isSelected =
                  _workouts[index].workoutName == type.workoutName;
              return GestureDetector(
                onTap: () {
                  setState(() => _workouts[index] = type);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? type.accentColor.withOpacity(0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? type.accentColor : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(type.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 12),
                      Text(
                        type.workoutName,
                        style: TextStyle(
                          color: isSelected
                              ? type.accentColor
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: type.accentColor,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutDay w, int index) {
    final isSelected = index == 0;

    return Container(
      key: ValueKey(w.day),
      width: 110,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: w.isRest
            ? AppColors.surface.withOpacity(0.5)
            : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? w.accentColor : w.accentColor.withOpacity(0.3),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      w.day,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      w.dateLabel,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.edit_rounded,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: w.accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: w.accentColor.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(w.emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              w.workoutName,
              style: TextStyle(
                color: w.isRest ? AppColors.textSecondary : w.accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            if (!w.isRest) ...[
              const SizedBox(height: 2),
              Text(
                w.duration,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Database-Connected Monthly Challenges ──────────────────────────────
  Widget _buildMonthlyChallenge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your monthly challenges',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: SupabaseService.getChallengesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.accent));
            }

            final dbChallenges = snapshot.data ?? [];

            if (dbChallenges.isEmpty) {
              return const Text("No active challenges.", style: TextStyle(color: Colors.grey));
            }

            return Row(
              children: dbChallenges.map((c) {
                Color tagColor = AppColors.gold;
                if (c['tag_color'] == 'orange') tagColor = AppColors.legOrange;
                if (c['tag_color'] == 'purple') tagColor = AppColors.cardioPurple;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildChallengeCard(Challenge(
                      title: c['title'] ?? 'Gym Challenge',
                      reward: c['reward'] ?? 'Gym Merch',
                      current: c['current_progress'] ?? 0,
                      total: c['total_goal'] ?? 100,
                      daysLeft: c['days_left'] ?? 30,
                      tagColor: tagColor,
                    )),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChallengeCard(Challenge c) {
    final progress = c.total > 0 ? (c.current / c.total) : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  c.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: c.tagColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${c.daysLeft}d left',
                  style: TextStyle(
                    color: c.tagColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: AppColors.gold,
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                c.reward,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
              Text(
                '${c.current} / ${c.total}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.isNaN || progress.isInfinite ? 0.0 : progress,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.8 ? AppColors.accent : AppColors.hiitYellow,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}