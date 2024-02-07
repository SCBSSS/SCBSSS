import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';

class JournalEntryView extends StatelessWidget {
  JournalEntry entry;

  JournalEntryView(this.entry, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                  style: const TextStyle(fontWeight: FontWeight.bold), entry.title),
              Text(entry.entry),
            ],
          ),
        ),
      ),
    );
  }
}
