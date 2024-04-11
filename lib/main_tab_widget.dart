import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/services/audio_recorder.dart';
import 'package:scbsss/tabs/add_entry_tab.dart';
import 'package:scbsss/tabs/data_tab.dart';
import 'package:scbsss/tabs/entries_tab.dart';
import 'package:scbsss/tabs/settings_tab.dart';

class MainTabWidget extends StatefulWidget {
  final void Function(JournalEntry entry) createNewEntryCallback;
  final void Function(JournalEntry entry) updateEntryCallback;
  final ValueNotifier<List<JournalEntry>> journalEntries;
  final AudioRecorder _audioRecorder;

  MainTabWidget({
    Key? key,
    required this.updateEntryCallback,
    required this.createNewEntryCallback,
    required this.journalEntries,
    required AudioRecorder audioRecorder,
  })  : _audioRecorder = audioRecorder,
        super(key: key);

  @override
  State<MainTabWidget> createState() =>
      _MainTabWidgetState(createNewEntryCallback,updateEntryCallback, journalEntries, _audioRecorder);
}

class _MainTabWidgetState extends State<MainTabWidget> {
  final ValueNotifier<List<JournalEntry>> journalEntries;
  final void Function(JournalEntry entry) createNewEntryCallback;
  final void Function(JournalEntry entry) updateEntryCallback;
  int currentTabIndex = 0;
  final AudioRecorder _audioRecorder;

  _MainTabWidgetState(this.createNewEntryCallback,this.updateEntryCallback, this.journalEntries, this._audioRecorder) {
    journalEntries.addListener(() {
      setState(() {});
    });
  }

  Widget getTab(int index) {
    switch (index) {
      case 0:
        return AddEntryTab(createOrUpdateEntry, _audioRecorder);
      case 1:
        return EntriesTab(journalEntries: journalEntries.value, audioRecorder: _audioRecorder, createOrUpdateEntryCallback: createOrUpdateEntry);
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

  void createOrUpdateEntry(JournalEntry entry, bool isNewEntry) {
    if(isNewEntry) {
      createNewEntryCallback(entry);
    } else {
      updateEntryCallback(entry);
    }
  }

}
