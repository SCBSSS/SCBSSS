import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/views/journal_entry_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

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
        title: Text('Previous Entries'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 8),
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
                Icon(CupertinoIcons.list_bullet, size: 16,color: Colors.white,),
                Icon(CupertinoIcons.calendar, size: 16,color: Colors.white,),
              ],
              onToggle: (index) {
                setState(() {
                  _viewType = index == 0 ? ViewType.timeline : ViewType.calendar;
                });
              },
            ),
          ),
        ],
      ),
      body: Expanded(
        child: _viewType == ViewType.timeline
            ? TimelineView(entries: widget.journalEntries)
            : CalendarView(dummyJournalEntries: widget.journalEntries),
      ),
    );
  }
}

class TimelineView extends StatelessWidget {
  late List<JournalEntry> entries;

  TimelineView({entries = List<JournalEntry>, super.key}) {
    this.entries = entries
        .where((element) => element.title != null || element.entry != null)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: entries.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox.shrink();
          }
          index--;
          final item = entries[index];
          if (item is JournalEntry) {
            return JournalEntryView(item);
          }
          if (item is DateTime) {}
        },
        separatorBuilder: (context, index) {
          bool showDate = false;
          var current = entries[index].date;
          if (index == 0) {
            showDate = true;
          } else {
            var prev = entries[index - 1].date;
            showDate = !(current.year == prev.year &&
                current.month == prev.month &&
                current.day == prev.day);
          }
          if (showDate) {
            final dateFormat = DateFormat('EEEE, MMM d');
            String currentDate = dateFormat.format(current).toUpperCase();
            return Padding(
              padding: (index > 0)
                  ? EdgeInsets.fromLTRB(16, 16, 0, 0)
                  : EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentDate,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(color: Color.fromARGB(255, 226, 225, 228)),
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
