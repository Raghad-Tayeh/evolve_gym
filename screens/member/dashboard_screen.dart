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

// ---- Sample Data ------
final List<ClassItem> classes = [
  ClassItem(
    day: 'Mon',
    date: 20,
    name: 'Strength & Conditioning',
    instructor: 'Marcus Rodriguez',
    time: '09:00 am – 12:00 pm',
    color: AppColors.chestGreen,
  ),
  ClassItem(
    day: 'Tue',
    date: 21,
    name: 'Hip Hop Step Class',
    instructor: 'Mike Torres',
    time: '11:30 am – 12:00 pm',
    color: AppColors.cardioPurple,
  ),
  ClassItem(
    day: 'Thu',
    date: 23,
    name: 'Boxing Fundamentals',
    instructor: 'William Kelly',
    time: '11:30 am – 12:00 pm',
    color: AppColors.legOrange,
  ),
  ClassItem(
    day: 'Fri',
    date: 24,
    name: 'Strength & Conditioning',
    instructor: 'Marcus Rodriguez',
    time: '11:30 am – 12:00 pm',
    color: AppColors.chestGreen,
  ),
  ClassItem(
    day: 'Sun',
    date: 26,
    name: 'Strength & Conditioning',
    instructor: 'Marcus Rodriguez',
    time: '11:30 am – 12:00 pm',
    color: AppColors.armsRed,
  ),
];

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

final List<Challenge> challenges = [
  Challenge(
    title: 'August Challenge: 20 Workouts',
    reward: 'Free Personal Training Session',
    current: 17,
    total: 20,
    daysLeft: 3,
    tagColor: AppColors.legOrange,
  ),
  Challenge(
    title: 'Cardio King',
    reward: 'Limited Edition Gym Merch',
    current: 180,
    total: 300,
    daysLeft: 10,
    tagColor: AppColors.legOrange,
  ),
];

// ---- Member Dashboard ------

class MemberDashboard extends StatelessWidget {
  const MemberDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTopBar();
  }

  Widget _buildTopBar() {
    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  Icons.dark_mode_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: () {},
              ),
              Stack(
                children: [
                  _topBarIcon(Icons.notifications_none_rounded),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.armsRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBarIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon, color: AppColors.textSecondary, size: 20),
      onPressed: () {},
    );
  }
}
