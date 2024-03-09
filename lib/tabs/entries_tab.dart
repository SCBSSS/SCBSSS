/*
import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:scbsss/models/mood_entry.dart';
import '../services/data_handler.dart';
import 'edit_scree.dart';

class EntriesTab extends StatefulWidget {
  @override
  State<EntriesTab> createState() => _EntriesTabState();
}

class _EntriesTabState extends State<EntriesTab> {
  late StreamController<List<MoodEntry>> _streamController;
  late Future<List<MoodEntry>> futureMoodEntries;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<MoodEntry>>.broadcast();
    futureMoodEntries = fetchMoodEntries();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<List<MoodEntry>> fetchMoodEntries() async {
    List<MoodEntry> entries = await DatabaseHelper().getAllMoodEntries();
    _streamController.add(entries);
    return entries;
  }*/
import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/views/journal_entry_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/cupertino.dart';

class EntriesTab extends StatefulWidget {
  final List<JournalEntry> journalEntries;

  EntriesTab({required this.journalEntries, super.key});

  @override
  State<EntriesTab> createState() => _EntriesTabState();
}

enum ViewType { timeline, calendar }

class _EntriesTabState extends State<EntriesTab> {
  ViewType _viewType = ViewType.timeline; //default viewtype; timeline

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*
      body: StreamBuilder<List<MoodEntry>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                "No Entry Added!!!",
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 18),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No Entry Added!!!",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                MoodEntry entry = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                    Colors.black.withOpacity(0.5),
                                    child: Text(
                                      entry.mood.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      entry.title.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // TODO: Implement edit functionality
                                _editEntry(entry);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                  Icons.delete, color: Colors.red),
                              onPressed: () {
                                // TODO: Implement delete functionality
                                _deleteEntry(entry);
                              },
                            ),
                          ],
                        ),
                        Text(
                          entry.notes.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _deleteEntry(MoodEntry entry) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this entry?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Not confirmed
              },
              child: Text('Cancel'),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // TODO: Implement edit functionality
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmed
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await DatabaseHelper().deleteMoodEntry(entry.id!);

      setState(() {
        futureMoodEntries = fetchMoodEntries();
      });

      CherryToast.error(
          title: Text("Deleted", style: TextStyle(color: Colors.black)))
          .show(context);
    }
  }

  void _editEntry(MoodEntry entry) async {
    MoodEntry updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEntryScreen(moodEntry: entry),
      ),
    );

    if (updatedEntry != null) {
      // Update the UI with the updated entry
      setState(() {
        futureMoodEntries = fetchMoodEntries();
      });

      CherryToast.success(
          title: Text("Updated", style: TextStyle(color: Colors.black)))
          .show(context);
    }
    */
        title: Text('Entry Tab'),
      ),
      body: Column(
        children: <Widget>[
          ToggleSwitch(
            minWidth: 90.0,
            initialLabelIndex: 1,
            cornerRadius: 20.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: ['', ''], // Empty labels only icons
            icons: [
              CupertinoIcons.list_bullet_below_rectangle,
              CupertinoIcons.calendar
            ],
            activeBgColors: [
              [Colors.blue],
              [Colors.pink]
            ],
            onToggle: (index) {
              print('switched to: $index');
              setState(() {
                // Update your view type based on the toggle index
                _viewType = index == 0 ? ViewType.timeline : ViewType.calendar;
              });
            },
          ),
          Expanded(
            child: _viewType == ViewType.timeline
                ? TimelineView(entries: widget.journalEntries)
                : CalendarView(dummyJournalEntries: widget.journalEntries),
          ),
        ],
      ),
    );
  }
}

class TimelineView extends StatelessWidget {
  final List<JournalEntry> entries;

  TimelineView({required this.entries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        JournalEntry entry = entries[index];
        return JournalEntryView(entry); // No need to pass dayNumber anymore
      },
    );
  }
}

class CalendarView extends StatefulWidget {
  final List<JournalEntry> dummyJournalEntries;
  //calendar class

  CalendarView({Key? key, required this.dummyJournalEntries}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  //calendar view UI
  late CalendarFormat _calendarFormat; //month, weeks, two weeks view
  late DateTime _focusedDay; //current week, month, day
  DateTime? _selectedDay; //selected date

  Set<DateTime> get datesWithEntries {
    return widget.dummyJournalEntries
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
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          //call
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update
          });
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
      calendarBuilders: CalendarBuilders(
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
                style: TextStyle(color: Colors.blue),
              ),
            );
          }
          // If not, return a default widget
          return null;
        },
      ),
    );
  }
}
