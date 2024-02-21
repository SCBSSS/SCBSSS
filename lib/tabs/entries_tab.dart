import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/views/journal_entry_view.dart';
import 'package:table_calendar/table_calendar.dart';

class EntriesTab extends StatefulWidget {
  List<JournalEntry> dummyJournalEntries;
  EntriesTab(this.dummyJournalEntries, {super.key});

  @override
  State<EntriesTab> createState() => _EntriesTabState();
}

enum ViewType { timeline, calendar }

class _EntriesTabState extends State<EntriesTab> {
  ViewType _viewType = ViewType.timeline; //default viewtype; timeline

  Widget _buildRadioViewType(ViewType viewType, String title) {
    //radio switch
    return Expanded(
      child: ListTile(
        //list between two variables timeline & calendar
        title: Text(title),
        leading: Radio<ViewType>(
          value: viewType,
          groupValue: _viewType,
          onChanged: (ViewType? value) {
            //Accepts nulls
            if (value != null) {
              setState(() => _viewType = value);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title
        title: Text('Entry Tab'),
      ),
      body: Column(
        //radio button
        children: <Widget>[
          Row(
            children: <Widget>[
              _buildRadioViewType(ViewType.timeline, 'Timeline'),
              _buildRadioViewType(ViewType.calendar, 'Calendar'),
            ],
          ),
          Expanded(
            // timelind and calendar ddpending on the viewtype
            child: _viewType == ViewType.timeline
                ? TimelineView()
                : CalendarView(),
          ),
        ],
      ),
    );
  }
}

class TimelineView extends StatelessWidget {
  //timeline class
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Timeline View'));
  }
}

class CalendarView extends StatefulWidget {
  //calendar class
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  //calendar view UI
  late CalendarFormat _calendarFormat; //month, weeks, two weeks view
  late DateTime _focusedDay; //current week, month, day
  DateTime? _selectedDay; //selected date

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
      onFormatChanged: (format) {   //format of the calendar changing (might change this UI function)
        if (_calendarFormat != format) {
          //call
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {  //updating page 
        //no need to call (why?)
        _focusedDay = focusedDay;
      },
    );
  }
}
