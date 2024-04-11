import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Color.fromARGB(255, 144, 199, 168),
            labelColor: Color.fromARGB(255, 144, 199, 168),
            unselectedLabelColor: Colors.white,
            isScrollable: false,
            labelPadding: EdgeInsets.all(0),
            labelStyle: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white),
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Account'),
              Tab(text: 'Notifications'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 207, 233, 222)!,
                Color.fromARGB(255, 205, 235, 237)!,
              ],
            ),
          ),
          child: const TabBarView(
            children: [
              GeneralSettings(),
              Center(child: Text('Account Settings')),
              Center(child: Text('Notification Settings')),
            ],
          ),
        ),
      ),
    );
  }
}

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

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
        ListTile(
          title: const Text('Data Backup'),
          trailing: IconButton(
            icon: const Icon(Icons.backup),
            onPressed: () {
              // Backup data
            },
          ),
        ),
      ],
    );
  }
}

//colors saved for bg gradient
// Color.fromARGB(255, 219, 234, 220)!,
// Color.fromARGB(255, 94, 137, 134)!,
// Color.fromARGB(255, 99, 126, 100)!,],
