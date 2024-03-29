import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/services/audio_recorder.dart';
import 'package:scbsss/tabs/add_entry_tab.dart';
import 'package:scbsss/tabs/data_tab.dart';
import 'package:scbsss/tabs/entries_tab.dart';
import 'package:scbsss/tabs/settings_tab.dart';
import 'package:scbsss/tabs/well-being.dart';

class MainTabWidget extends StatefulWidget {
  final void Function(JournalEntry entry) createNewEntryCallback;
  final ValueNotifier<List<JournalEntry>> journalEntries;
  final AudioRecorder _audioRecorder;

  MainTabWidget({
    Key? key,
    required this.createNewEntryCallback,
    required this.journalEntries,
    required AudioRecorder audioRecorder,
  })  : _audioRecorder = audioRecorder,
        super(key: key);

  @override
  State<MainTabWidget> createState() =>
      _MainTabWidgetState(createNewEntryCallback, journalEntries, _audioRecorder);
}

class _MainTabWidgetState extends State<MainTabWidget> {
  final ValueNotifier<List<JournalEntry>> journalEntries;
  final void Function(JournalEntry entry) createNewEntryCallback;
  int currentTabIndex = 0;
  final AudioRecorder _audioRecorder;

  _MainTabWidgetState(this.createNewEntryCallback, this.journalEntries, this._audioRecorder) {
    journalEntries.addListener(() {
      setState(() {});
    });
  }

  Widget getTab(int index) {
    switch (index) {
      case 0:
        return AddEntryTab(createNewEntryCallback, _audioRecorder);
      case 1:
        return EntriesTab(journalEntries: journalEntries.value);
      case 2:
        return DataTab();
      case 3:
        return WellBeing();
      case 4:
        return SettingsTab();
      default:
        throw Exception('Invalid tab index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getTab(currentTabIndex),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(16),
            gap: 12,
            tabs: const [
              GButton(icon: CupertinoIcons.add,
              text: 'Add Entry',),
              GButton(icon: CupertinoIcons.list_bullet,
              text: 'Entries'),
              GButton(icon: CupertinoIcons.graph_square,
              text: 'Data'),
              GButton(icon: CupertinoIcons.metronome,
              text: "Well-being"),
              GButton(icon: CupertinoIcons.settings,
              text: 'Settings')
            ],
            onTabChange: (int index) {
              setState(() {
                currentTabIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
