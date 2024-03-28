import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scbsss/notification_service.dart'; // Import the notification service file

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.orange[300],
          elevation: 0,
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            isScrollable: false,
            labelPadding: EdgeInsets.all(0),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16),
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Account'),
              Tab(text: 'Notifications'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GeneralSettings(),
            Center(
              child: Text(
                'Account Settings',
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
            ),
            Center(
              child: NotificationsSettings(),
            ),
          ],
        ),
      ),
    );
  }
}

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  bool _lightTheme = false;
  bool _notificationsEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Light Theme'),
          value: _lightTheme,
          onChanged: (bool value) {
            setState(() {
              _lightTheme = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Enable Notifications'),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        ListTile(
          title: const Text('Language'),
          trailing: DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
              });
            },
            items: <String>['English', 'Spanish', 'French', 'German']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class NotificationsSettings extends StatelessWidget {
  const NotificationsSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _showTestNotification,
            child: Text('Show Test Notification'),
          ),
          ElevatedButton(
            onPressed: () {
              // Add logic to handle scheduling notifications
            },
            child: Text('Schedule Notification'),
          ),
        ],
      ),
    );
  }

  // Method to show a test notification
  Future<void> _showTestNotification() async {
    createNotification(); // Call the createNotification method
  }
}
