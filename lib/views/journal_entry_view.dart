import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:scbsss/models/journal_entry.dart';

class JournalEntryView extends StatelessWidget {
  final JournalEntry entry;

  JournalEntryView(this.entry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the intl package to format dates.
    // If you haven't already, add 'intl' to your pubspec.yaml file.
    // final String formattedDate = DateFormat('EEEE, MMM d').format(entry.date);

    final formattedTime = DateFormat('h:mm a').format(entry.date);
    final moodColor = getMoodColor(entry.mood);
    final moodDisplay =
        '${entry.mood} ${_getMoodEmoji(entry.mood)}'; // Updated to just include the mood level and emoji

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: moodColor,
              ),
              width: 4,
            ),
            SizedBox(width: 7),
            Text(moodDisplay,
                style: TextStyle(
                    fontSize: 20)), // Display the emoji and mood level
            SizedBox(width: 7),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entry.title != null && entry.title!.isNotEmpty)
                    Text(
                      entry.title!,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  Text(
                    entry.entry ?? '',
                    style: TextStyle(color: CupertinoColors.inactiveGray),
                  ),
                ],
              ),
            ),
            Text(formattedTime),
          ],
        ),
      ),
    );
  }

  String _getMoodEmoji(int mood) {
    // Switch case to determine the emoji based on the mood value
    switch (mood) {
      case 1:
        return '😡'; // Mood level 1
      case 2:
        return '😢'; // Mood level 2
      case 3:
        return '😑'; // Mood level 3
      case 4:
        return '😊'; // Mood level 4
      case 5:
        return '😁'; // Mood level 5
      default:
        return '😑'; // Default case if mood is out of expected range
    }
  }

  getMoodColor(int mood) {
    const red = CupertinoColors.systemRed;
    const orange = CupertinoColors.systemOrange;
    const green = CupertinoColors.systemGreen;

    if (mood <= 2) {
      return Color.lerp(red, orange, mood / 2.0);
    } else {
      return Color.lerp(orange, green, (mood - 2) / 2.0);
    }
  }
}
