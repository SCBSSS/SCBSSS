import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/views/journal_entry_view.dart';

class EntriesTab extends StatelessWidget {
  List<JournalEntry> dummyJournalEntries;
  EntriesTab(this.dummyJournalEntries);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Column(
          children: dummyJournalEntries.map((e) => JournalEntryView(e)).toList(),
        ),
      ),
    );
  }
}