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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entries'),
      ),
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
  }
}
