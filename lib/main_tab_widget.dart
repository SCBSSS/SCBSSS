import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scbsss/tabs/add_entry_tab.dart';
import 'package:scbsss/tabs/data_tab.dart';
import 'package:scbsss/tabs/entries_tab.dart';
import 'package:scbsss/tabs/settings_tab.dart';

class MainTabWidget extends StatefulWidget {
  const MainTabWidget({super.key});

  @override
  State<MainTabWidget> createState() => _MainTabWidgetState();
}

class _MainTabWidgetState extends State<MainTabWidget> {
  final tabs = [
    AddEntryTab(),
    EntriesTab(),
    DataTab(),
    SettingsTab(),
  ];
  int currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
            label: "Add Entry",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: "Entries",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square),
            label: "Data",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
