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
  final RecordingService audioRecorder;
  final void Function(JournalEntry entry, bool isnewEntry)
      createOrUpdateEntryCallback;

  const EntriesTab(
      {required this.journalEntries,
      super.key,
      required this.audioRecorder,
      required this.createOrUpdateEntryCallback});

  @override
  State<EntriesTab> createState() => _EntriesTabState(
      audioRecorder: audioRecorder,
      createOrUpdateEntryCallback: createOrUpdateEntryCallback);
}

enum ViewType { timeline, calendar }

class _EntriesTabState extends State<EntriesTab> {
  ViewType _viewType = ViewType.timeline; //default viewtype; timeline
  final RecordingService audioRecorder;
  final void Function(JournalEntry entry, bool isnewEntry)
      createOrUpdateEntryCallback;
  final int? selectedItem = null;

  _EntriesTabState(
      {required this.audioRecorder, required this.createOrUpdateEntryCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildEntriesAppBar(),
      body: _viewType == ViewType.timeline
          ? TimelineView(
              entries: widget.journalEntries,
              audioRecorder: audioRecorder,
              createOrUpdateEntryCallback: createOrUpdateEntryCallback,
              selectedItem: selectedItem,
            )
          : CalendarView(
              journalEntries: widget.journalEntries,
              audioRecorder: audioRecorder,
              createOrUpdateEntryCallback: createOrUpdateEntryCallback),
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
                _viewType = index == 0 ? ViewType.timeline : ViewType.calendar;
              });
            },
          ),
        ),
      ],
    );
  }
}

class TimelineView extends StatefulWidget {
  final List<JournalEntry> shownEntries;

  final RecordingService audioRecorder;
  final void Function(JournalEntry entry, bool isnewEntry)
      createOrUpdateEntryCallback;
  final int? selectedItem;

  TimelineView(
      {required List<JournalEntry> entries,
      required this.audioRecorder,
      required this.createOrUpdateEntryCallback,
      super.key,
      this.selectedItem})
      : shownEntries = entries
            .where((element) => element.title != null || element.entry != null)
            .toList(growable: false);

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  int? selectedItem = null;

  _TimelineViewState({this.selectedItem});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: widget.shownEntries.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox.shrink();
          }
          index--;
          final item = widget.shownEntries[index];
          return JournalEntryView(item,
              audioRecorder: widget.audioRecorder,
              createOrUpdateEntryCallback: widget.createOrUpdateEntryCallback);
        },
        separatorBuilder: (context, index) {
          bool showDate = false;
          var current = widget.shownEntries[index].date;
          if (index == 0) {
            showDate = true;
          } else {
            var prev = widget.shownEntries[index - 1].date;
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
  final RecordingService audioRecorder;
  final void Function(JournalEntry entry, bool isnewEntry)
      createOrUpdateEntryCallback;

  //calendar class

  CalendarView(
      {Key? key,
      required this.journalEntries,
      required this.audioRecorder,
      required this.createOrUpdateEntryCallback})
      : super(key: key);

  @override
  _CalendarViewState createState() =>
      _CalendarViewState(this.audioRecorder, this.createOrUpdateEntryCallback);
}

class _CalendarViewState extends State<CalendarView> {
  //calendar view UI
  late CalendarFormat _calendarFormat; //month, weeks, two weeks view
  late DateTime _focusedDay; //current week, month, day
  DateTime? _selectedDay; //selected date
  final RecordingService audioRecorder;
  final void Function(JournalEntry entry, bool isnewEntry)
      createOrUpdateEntryCallback;

  List<JournalEntry>? findJournalEntryForDate(DateTime date) {
    //  to find a journal entry within a specific date
    try {
      return widget.journalEntries
          .where(
            (entry) => isSameDay(entry.date, date),
          )
          .toList();
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
    _selectedDay = _focusedDay; //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar View')),
      body: ListView.builder(
        itemCount: 12, // number of months in a year
        itemBuilder: (context, index) {
          // calculate the first day of each month
          DateTime firstDayOfMonth =
              DateTime(DateTime.now().year, index + 1, 1);
          DateTime lastDayOfMonth = (index + 1 < 12)
              ? DateTime(DateTime.now().year, index + 2, 0)
              : DateTime(DateTime.now().year + 1, 1, 0);

          // ensure the focusedDay is not before the firstDay and not after the lastDay
          if (_selectedDay!.isBefore(firstDayOfMonth)) {
            _selectedDay = firstDayOfMonth;
          } else if (_selectedDay!.isAfter(lastDayOfMonth)) {
            _selectedDay = lastDayOfMonth;
          }

          return ExpansionTile(
            title: Text(DateFormat('MMMM yyyy').format(firstDayOfMonth)),
            children: [
              SizedBox(
                height: 400, // Set a fixed height for the calendar
                child: TableCalendar(
                  firstDay: firstDayOfMonth,
                  lastDay: lastDayOfMonth,
                  focusedDay: _selectedDay ?? firstDayOfMonth,
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  headerStyle: HeaderStyle(formatButtonVisible: false),
                  // Hides the format button
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      bool hasEntries = datesWithEntries
                          .contains(DateTime(day.year, day.month, day.day));
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: hasEntries
                                ? Color.fromARGB(255, 1, 77, 230)
                                : Colors.black,
                            fontWeight: hasEntries
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    final entries = findJournalEntryForDate(selectedDay);
                    if (entries != null && entries.isNotEmpty) {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Card(
                            child: ListView.separated(
                              itemCount: entries.length,
                              itemBuilder: (context, index) {
                                final item = entries[index];
                                return JournalEntryView(item,
                                    audioRecorder: audioRecorder,
                                    createOrUpdateEntryCallback:
                                        createOrUpdateEntryCallback);
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                    color: Color.fromARGB(255, 226, 225, 228));
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    ); // Closes Scaffold
  } // Closes build method

  String getEmojiForMood(int mood) {
    List<String> moodEmojis = ['😡', '😢', '😐', '😊', '😁']; //moods are 1-5
    return moodEmojis[mood -
        1]; //so subtracting 1 from the mood gets the associated emoji we want
  }

  _CalendarViewState(
    this.audioRecorder,
    this.createOrUpdateEntryCallback,
  );
}
