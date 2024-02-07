import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/tabs/add_entry_tab.dart';
import 'package:scbsss/tabs/data_tab.dart';
import 'package:scbsss/tabs/entries_tab.dart';
import 'package:scbsss/tabs/settings_tab.dart';
import 'package:scbsss/db/database_service.dart';

class MainTabWidget extends StatefulWidget {
  const MainTabWidget({super.key});

  @override
  State<MainTabWidget> createState() => _MainTabWidgetState();
}

class _MainTabWidgetState extends State<MainTabWidget> {

  List<JournalEntry> dummyJournalEntries = [];
  int currentTabIndex = 0;

  void initDb() async {
    await DatabaseService.instance.database;
  }

  void getJournalEntries() async {
    await DatabaseService.instance.getAllJournalEntries().then((value) {
      setState(() {
        dummyJournalEntries = value;
      });
    }).catchError((error) => debugPrint(error.toString()));
  }

  @override
  void initState() {
    initDb();
    getJournalEntries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      AddEntryTab(),
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
}
