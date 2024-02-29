import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scbsss/models/journal_entry.dart';

class JournalEntryView extends StatelessWidget {
  final JournalEntry entry;

  JournalEntryView(this.entry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the intl package to format dates.
    // If you haven't already, add 'intl' to your pubspec.yaml file.
    final String formattedDate = DateFormat('EEEE, MMM d').format(entry.date);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              width: 3.0, color: Colors.orange), // Adjust the color as needed
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate, // This will display the formatted date of the entry.
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4), // Spacing between date and title
            Text(
              entry.title ?? 'No Title',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4), // Spacing between title and entry
            Text(entry.entry ?? 'No Entry'), // Entry text
          ],
        ),
      ),
    );
  }
}
