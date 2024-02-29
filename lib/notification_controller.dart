import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {
  //dctect when a new notification is created or schedueled
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  //dctect everytime a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  //dctect when user dismisses the notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receivedNotification) async {}

  //dctect when the user taps on notification
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification) async {}
}
