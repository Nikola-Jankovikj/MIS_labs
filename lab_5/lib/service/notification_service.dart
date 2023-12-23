import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lab_3/service/location_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/Midterm.dart';

class NotificationService {
  int idCount = 0;
  bool locationNotifActive = false;
  double finkiLat = 42.004186212873655;
  double finkiLon = 21.409531941596985;
  DateTime? lastNotificationTime;

  NotificationService() {
    // Start checking location periodically
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (locationNotifActive) {
        checkLocationAndNotify();
      }
    });
  }

  void scheduleNotificationsForExistingMidterms(midterms) {
    for (int i = 0; i < midterms.length; i++) {
      scheduleNotification(midterms[i]);
    }
  }

  void scheduleNotification(Midterm midterm) {
    final int notificationId = idCount++;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: "basic_channel",
        title: midterm.subject,
        body: "You have a midterm tomorrow!",
      ),
      schedule: NotificationCalendar(
        day: midterm.date.subtract(const Duration(days: 1)).day,
        month: midterm.date.subtract(const Duration(days: 1)).month,
        year: midterm.date.subtract(const Duration(days: 1)).year,
        hour: midterm.date.subtract(const Duration(days: 1)).hour,
        minute: midterm.date.subtract(const Duration(days: 1)).minute,
      ),
    );
  }

  Future<void> toggleLocationNotification() async {
    locationNotifActive = !locationNotifActive;

    if (locationNotifActive) {
      // If notifications are activated, immediately check location
      checkLocationAndNotify();
    }
  }

  Future<void> checkLocationAndNotify() async {
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      bool theSameLocation = false;
      LocationService().getCurrentLocation().then((value) {
        if ((value.latitude < finkiLat + 0.01 && value.latitude > finkiLat - 0.01) &&
            (value.longitude < finkiLon + 0.01 && value.longitude > finkiLon - 0.01)) {
          theSameLocation = true;
        }
        if (theSameLocation && canSendNotification()) {
          // Trigger notification
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: idCount++,
              channelKey: "basic_channel",
              title: "Work!",
              body: "You have a midterm soon!",
            ),
          );
          // Set the lastNotificationTime to the current time
          lastNotificationTime = DateTime.now();
        }
      });
    }
  }

  bool canSendNotification() {
    // Check if lastNotificationTime is null or more than 10 minutes ago
    return lastNotificationTime == null ||
        DateTime.now().difference(lastNotificationTime!) > Duration(minutes: 10);
  }
}
