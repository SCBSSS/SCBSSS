//Final Edit

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:scbsss/main_tab_widget.dart';
import 'package:scbsss/notification_controller.dart';
import 'package:scbsss/setup_wizard.dart';
import 'package:scbsss/services/database_service.dart';

void main() async {
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

//this asks the user to give the app permission to send notifications
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSetupDone = false;
  bool isLoading = true;

  void completeSetup() {
    setState(() {
      isSetupDone = true;
    });
  }

  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await DatabaseService.instance.database; // wait for db to get initalized

    setState(() {
      isLoading = false; // update loading state
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return MaterialApp(
        home: Scaffold(
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 1,
                    channelKey: "basic_channel",
                    title: "Time for Mood Entry",
                    body: "Please enter your daily mood entry",
                  ),
                );
              },
              child: Icon(
                Icons.notification_add,
              )),
          body: Center(
            child: CircularProgressIndicator(), // show loading indicator
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: isSetupDone ? MainTabWidget() : SetupWizard(completeSetup),
    );
  }
}
