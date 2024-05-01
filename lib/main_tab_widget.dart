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
  late PageController _pageController;

  _MainTabWidgetState(this.createNewEntryCallback,this.updateEntryCallback, this.journalEntries, this._audioRecorder) {
    journalEntries.addListener(() {
      setState(() {});
    });
    _pageController = PageController(); // Initialize the PageController
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          AddEntryTab(createOrUpdateEntry, _audioRecorder,journalEntries: journalEntries,),
          EntriesTab(audioRecorder: _audioRecorder,journalEntries: journalEntries.value, createOrUpdateEntryCallback: createOrUpdateEntry),
          DataTab(),
          WellBeing(),
          SettingsTab(),
        ],
      ),
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
              _pageController.animateToPage(index, duration: Duration(milliseconds: 600), curve: Curves.linearToEaseOut);
            },
          ),
        ),
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
