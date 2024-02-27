import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/tabs/add_entry_tab.dart';
import 'package:scbsss/tabs/data_tab.dart';
import 'package:scbsss/tabs/entries_tab.dart';
import 'package:scbsss/tabs/settings_tab.dart';

class MainTabWidget extends StatefulWidget {
  void Function(JournalEntry entry) createNewEntryCallback;
  MainTabWidget({super.key,required this.createNewEntryCallback});

  @override
  State<MainTabWidget> createState() => _MainTabWidgetState(createNewEntryCallback);
}

class _MainTabWidgetState extends State<MainTabWidget> {

  void Function(JournalEntry entry) createNewEntryCallback;

  final dummyJournalEntries = [
    JournalEntry(
        id: 1,
        mood: 1,
        title: "Day 1 of classes",
        entry: "Classes went well",
        date: DateTime.now()),
    JournalEntry(
        id: 2,
        mood: 3,
        title: "Day 2 of classes",
        entry: "Classes were okay",
        date: DateTime.now()),
    JournalEntry(
        id: 3,
        mood: 5,
        title: "Day 3 of classes",
        entry: "Classes were excellent",
        date: DateTime.now()),
    JournalEntry(
        id: 4,
        mood: 2,
        title: "Day 4 of classes",
        entry: "Classes were not so good",
        date: DateTime.now()),
    JournalEntry(
        id: 5,
        mood: 4,
        title: "Day 5 of classes",
        entry: "Classes were good",
        date: DateTime.now()),
  ];
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      AddEntryTab(createNewEntryCallback),
      EntriesTab(dummyJournalEntries),
      DataTab(),
      SettingsTab(),
    ];
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

  _MainTabWidgetState(this.createNewEntryCallback);
}
