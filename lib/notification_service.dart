import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:scbsss/notification_controller.dart';

Future<void> initializeNotifications() async {
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: "basic_channel_group",
        channelKey: "basic_channel",
        channelName: "basic notification",
        channelDescription: "basic notifications channel",
        importance: NotificationImportance.High,
        defaultColor: Colors.teal,
        ledColor: Colors.teal,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: "basic_channel_group",
        channelGroupName: "basic group",
      ),
    ],
  );

  // Asks user for permission
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
}

void setNotificationListeners() {
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    onNotificationCreatedMethod:
        NotificationController.onNotificationCreatedMethod,
    onNotificationDisplayedMethod:
        NotificationController.onNotificationDisplayedMethod,
    onDismissActionReceivedMethod:
        NotificationController.onDismissActionReceivedMethod,
  );
}

void createNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: "basic_channel",
      title: "Time for Mood Entry",
      body: "Please enter your daily mood entry",
    ),
  );
}
