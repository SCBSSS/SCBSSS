import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/views/journal_entry_view.dart';

class EntriesTab extends StatefulWidget {
  final List<JournalEntry> journalEntries;

  EntriesTab({required this.journalEntries});

  @override
  State<EntriesTab> createState() => _EntriesTabState();
}

enum EntriesTabViews {
  timeline,
calendar
}
class _EntriesTabState extends State<EntriesTab> {
  var currentView = EntriesTabViews.timeline;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Column(
          children: widget.journalEntries.map((e) => JournalEntryView(e))
              .toList(),
        ),
      ),
    );
  }
}