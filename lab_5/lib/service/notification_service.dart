import 'package:awesome_notifications/awesome_notifications.dart';

import '../model/Midterm.dart';

class NotificationService{
  int idCount = 0;

  void scheduleNotificationsForExistingMidterms(midterms) {
    for (int i = 0; i < midterms.length; i++) {
      scheduleNotification(midterms[i]);
    }
  }

  void scheduleNotification(Midterm midterm) {
    final int notificationId = idCount++;

    AwesomeNotifications().createNotification(
        content: NotificationContent(id: notificationId, channelKey: "basic_channel", title: midterm.subject, body: "You have a midterm tomorrow!"),
        schedule: NotificationCalendar(
            day: midterm.date.subtract(const Duration(days: 1)).day,
            month: midterm.date.subtract(const Duration(days: 1)).month,
            year: midterm.date.subtract(const Duration(days: 1)).year,
            hour: midterm.date.subtract(const Duration(days: 1)).hour,
            minute: midterm.date.subtract(const Duration(days: 1)).minute
        )
    );
  }
}