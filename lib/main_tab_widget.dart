import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/tabs/add_entry_tab.dart';
import 'package:scbsss/tabs/data_tab.dart';
import 'package:scbsss/tabs/entries_tab.dart';
import 'package:scbsss/tabs/settings_tab.dart';

class MainTabWidget extends StatefulWidget {
  final void Function(JournalEntry entry) createNewEntryCallback;
  final ValueNotifier<List<JournalEntry>> journalEntries;

  MainTabWidget({
    Key? key,
    required this.createNewEntryCallback,
    required this.journalEntries,
  }) : super(key: key);

  @override
  State<MainTabWidget> createState() => _MainTabWidgetState(createNewEntryCallback, journalEntries);
}

class _MainTabWidgetState extends State<MainTabWidget> {

  final ValueNotifier<List<JournalEntry>> journalEntries;
  final void Function(JournalEntry entry) createNewEntryCallback;
  int currentTabIndex = 0;

  _MainTabWidgetState(this.createNewEntryCallback, this.journalEntries){
    journalEntries.addListener(() {
      setState(() {});
    });
  }

  Widget getTab(int index) {
    switch (index) {
      case 0:
        return AddEntryTab(createNewEntryCallback);
      case 1:
        return EntriesTab(journalEntries: journalEntries.value);
      case 2:
        return DataTab();
      case 3:
        return SettingsTab();
      default:
        throw Exception('Invalid tab index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getTab(currentTabIndex),
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
