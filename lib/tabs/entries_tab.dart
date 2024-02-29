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
                ? TimelineView(entries: widget.dummyJournalEntries)
                : CalendarView(dummyJournalEntries: widget.dummyJournalEntries),
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
