import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> initializeNotifications() async {
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
  );
}

void createNotification(
    {required int id,
    required String title,
    required String body,
    DateTime? scheduleDate,
    bool includeMoodActions = false // Adding a flag to include mood actions
    }) {
  List<NotificationActionButton> moodActions = [];
  if (includeMoodActions) {
    moodActions = List<NotificationActionButton>.generate(
      5,
      (index) => NotificationActionButton(
        key: 'MOOD_$index',
        label: 'Mood ${index + 1}',
      ),
    );
  }

  NotificationContent notificationContent = NotificationContent(
    id: id,
    channelKey: 'basic_channel',
    title: title,
    body: body,
  );

  if (scheduleDate != null) {
    AwesomeNotifications().createNotification(
        content: notificationContent,
        schedule: NotificationCalendar.fromDate(date: scheduleDate),
        actionButtons: moodActions);
  } else {
    AwesomeNotifications().createNotification(
        content: notificationContent, actionButtons: moodActions);
  }
}

class ScheduleNotificationScreen extends StatefulWidget {
  const ScheduleNotificationScreen({super.key});

  @override
  _ScheduleNotificationScreenState createState() =>
      _ScheduleNotificationScreenState();
}

class _ScheduleNotificationScreenState
    extends State<ScheduleNotificationScreen> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _showTimePicker,
              child: const Text('Select Time'),
            ),
            // Button to schedule the notification
          ],
        ),
      ),
    );
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
      _showTestNotification();
    }
  }

  Future<void> _showTestNotification() async {
    final now = DateTime.now();
    final scheduleDateTime = DateTime(
        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
    createNotification(
        id: 2,
        title: 'Scheduled Notification',
        body: 'This is your scheduled notification.',
        scheduleDate: scheduleDateTime,
        includeMoodActions: true);
  }
}
