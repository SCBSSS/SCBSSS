import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/services/audio_recorder.dart';
import 'package:scbsss/views/journal_entry_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/cupertino.dart';

class EntriesTab extends StatefulWidget {
  final List<JournalEntry> journalEntries;
  final AudioRecorder audioRecorder;
  final void Function(JournalEntry entry, bool isnewEntry) createOrUpdateEntryCallback;

  const EntriesTab({required this.journalEntries, super.key, required this.audioRecorder, required this.createOrUpdateEntryCallback});

  @override
  State<EntriesTab> createState() => _EntriesTabState(audioRecorder: audioRecorder, createOrUpdateEntryCallback: createOrUpdateEntryCallback);
}

enum ViewType { timeline, calendar }

class _EntriesTabState extends State<EntriesTab> {
  ViewType _viewType = ViewType.timeline; //default viewtype; timeline
  final AudioRecorder audioRecorder;
  final void Function(JournalEntry entry, bool isnewEntry) createOrUpdateEntryCallback;

  _EntriesTabState({required this.audioRecorder, required this.createOrUpdateEntryCallback});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildEntriesAppBar(),
      body: _viewType == ViewType.timeline
          ? TimelineView(entries: widget.journalEntries, audioRecorder: audioRecorder, createOrUpdateEntryCallback: createOrUpdateEntryCallback)
          : CalendarView(journalEntries: widget.journalEntries),
    );
  }

  AppBar buildEntriesAppBar() {
    return AppBar(
      title: const Text('Previous Entries'),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          child: ToggleSwitch(
            minHeight: 30,
            minWidth: 40,
            initialLabelIndex: _viewType == ViewType.timeline ? 0 : 1,
            cornerRadius: 5.0,
            totalSwitches: 2,
            labels: ['', ''],
            activeFgColor: Colors.white,
            inactiveFgColor: Colors.white,
            customIcons: [
              const Icon(
                CupertinoIcons.list_bullet,
                size: 16,
                color: Colors.white,
              ),
              const Icon(
                CupertinoIcons.calendar,
                size: 16,
                color: Colors.white,
              ),
            ],
            onToggle: (index) {
              setState(() {
                _viewType =
                    index == 0 ? ViewType.timeline : ViewType.calendar;
              });
            },
          ),
        ),
      ],
    );
  }

}

class TimelineView extends StatelessWidget {
  final List<JournalEntry> shownEntries;

  final AudioRecorder audioRecorder;
  final void Function(JournalEntry entry, bool isnewEntry) createOrUpdateEntryCallback;
  TimelineView({required List<JournalEntry> entries,required this.audioRecorder,required this.createOrUpdateEntryCallback, super.key})
      : shownEntries = entries
            .where((element) => element.title != null || element.entry != null)
            .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: shownEntries.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox.shrink();
          }
          index--;
          final item = shownEntries[index];
          return JournalEntryView(item,audioRecorder: audioRecorder, createOrUpdateEntryCallback: createOrUpdateEntryCallback);
        },
        separatorBuilder: (context, index) {
          bool showDate = false;
          var current = shownEntries[index].date;
          if (index == 0) {
            showDate = true;
          } else {
            var prev = shownEntries[index - 1].date;
            showDate = !(current.year == prev.year &&
                current.month == prev.month &&
                current.day == prev.day);
          }
          if (showDate) {
            final dateFormat = DateFormat('EEEE, MMM d');
            String currentDate = dateFormat.format(current).toUpperCase();
            return Padding(
              padding: (index > 0)
                  ? const EdgeInsets.fromLTRB(16, 16, 0, 0)
                  : const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentDate,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Color.fromARGB(255, 226, 225, 228)),
                ],
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 0),
              child: Divider(color: Color.fromARGB(255, 226, 225, 228)),
            );
          }
        });
  }
}

class CalendarView extends StatefulWidget {
  final List<JournalEntry> journalEntries;

  //calendar class

  CalendarView({Key? key, required this.journalEntries}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  //calendar view UI
  late CalendarFormat _calendarFormat; //month, weeks, two weeks view
  late DateTime _focusedDay; //current week, month, day
  DateTime? _selectedDay; //selected date

  List<JournalEntry>? findJournalEntryForDate(DateTime date) {
    //  to find a journal entry within a specific date
    try {
      return widget.journalEntries.where(
        (entry) => isSameDay(entry.date, date),
      ).toList();
    } catch (e) {
      return null; //if no entry
    }
  }

  Set<DateTime> get datesWithEntries {
    return widget.journalEntries
        .map((entry) =>
            DateTime(entry.date.year, entry.date.month, entry.date.day))
        .toSet();
  }

  @override
  void initState() {
    //initialize
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    //incoperating tablecalendar
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        //code i will write later
        return isSameDay(_selectedDay, day) ?? false;
        //This gave an error without the 'null' even though it is not necesary becuase
        //there should always be a current day selected.
      },

      //fetching the journal entry for the selected day "content"
      onDaySelected: (selectedDay, focusedDay) {
        final entries = findJournalEntryForDate(selectedDay);
        if (entries != null && entries.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                  "Journal Entries for ${DateFormat('yMMMd').format(selectedDay)}",
                  style: const TextStyle(
                    fontSize: 20
                  ),),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    const Divider(
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                      height: 0
                    ),
                    const SizedBox(height: 20,),
                    ListBody(
                      children: entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (entry.title != null) Text("Title: ${entry.title}"),
                            if (entry.entry != null) Text("Content: ${entry.entry}"),
                            if (entry.entry != null) Text("Mood: ${getEmojiForMood(entry.mood)}"),
                            const SizedBox(height: 40,),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
      },

      onFormatChanged: (format) {
        //format of the calendar changing (might change this UI function)
        if (_calendarFormat != format) {
          //call
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        //updating page
        //no need to call (why?)
        _focusedDay = focusedDay;
      },

      /* calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          // Check if this day has an entry
          if (datesWithEntries.contains(day)) {
            // If it does, return a widget with a blue circle
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent, // or any color that fits your design
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Text(
                day.day.toString(),
                style: const TextStyle(color: Colors.blue),
              ),
            );
          }
          // If not, return a default widget
          return null;
        },
      ),*/
    );
  }

  String getEmojiForMood(int mood) {
    List<String> moodEmojis = ['😡', '😢', '😐', '😊', '😁']; //moods are 1-5
    return moodEmojis[mood - 1]; //so subtracting 1 from the mood gets the associated emoji we want
  }
}
