// lib/models/notification_model.dart

enum NotificationType { booking, payment, membership, challenge, general }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.type,
    this.isRead = false,
  });
}

// ─── Dummy Data ───────────────────────────────────────────────────────────────

final List<AppNotification> dummyNotifications = [
  AppNotification(
    id: '1',
    title: 'Class Booked Successfully',
    message:
        'Your booking for "Strength & Conditioning" on Monday, Nov 20 at 09:00 AM has been confirmed.',
    date: DateTime.now().subtract(const Duration(minutes: 10)),
    type: NotificationType.booking,
    isRead: false,
  ),
  AppNotification(
    id: '2',
    title: 'Payment Received',
    message:
        'Your membership payment of \$49.99 has been processed successfully. Your membership is active until Dec 31.',
    date: DateTime.now().subtract(const Duration(hours: 2)),
    type: NotificationType.payment,
    isRead: false,
  ),
  AppNotification(
    id: '3',
    title: 'Challenge Joined',
    message:
        'You have successfully joined the "30-Day Core Challenge". Keep it up — day 1 starts today!',
    date: DateTime.now().subtract(const Duration(hours: 5)),
    type: NotificationType.challenge,
    isRead: false,
  ),
  AppNotification(
    id: '4',
    title: 'Membership Expiring Soon',
    message:
        'Your membership expires in 22 days. Renew now to avoid interruption to your training.',
    date: DateTime.now().subtract(const Duration(days: 1)),
    type: NotificationType.membership,
    isRead: true,
  ),
  AppNotification(
    id: '5',
    title: 'Class Cancelled',
    message:
        '"Hip Hop Step Class" on Tuesday has been cancelled by the coach. We apologise for the inconvenience.',
    date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    type: NotificationType.booking,
    isRead: true,
  ),
  AppNotification(
    id: '6',
    title: 'Challenge Milestone Reached',
    message:
        '🔥 You\'ve completed 14 consecutive days in the "5K Running Challenge". You\'ve unlocked the "14-Day Streak" badge!',
    date: DateTime.now().subtract(const Duration(days: 2)),
    type: NotificationType.challenge,
    isRead: true,
  ),
  AppNotification(
    id: '7',
    title: 'New Class Available',
    message:
        'A new "Boxing Fundamentals" class has been added every Thursday at 11:30 AM. Spots are limited!',
    date: DateTime.now().subtract(const Duration(days: 3)),
    type: NotificationType.general,
    isRead: true,
  ),
  AppNotification(
    id: '8',
    title: 'Booking Cancelled',
    message:
        'Your booking for "Strength & Conditioning" on Sunday, Nov 26 has been cancelled successfully.',
    date: DateTime.now().subtract(const Duration(days: 4)),
    type: NotificationType.booking,
    isRead: true,
  ),
];
