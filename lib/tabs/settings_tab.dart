import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  final VoidCallback onGenerateNotification;

  const SettingsTab({Key? key, required this.onGenerateNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: onGenerateNotification,
            child: Text('Create Notification'),
          ),
          const SizedBox(height: 16),
          const Text('Settings'),
        ],
      ),
    );
  }
}
