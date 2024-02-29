import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/mood_entry.dart';
import '../services/data_handler.dart';

class AddEntryTab extends StatefulWidget {
  @override
  _AddEntryTabState createState() => _AddEntryTabState();
}

class _AddEntryTabState extends State<AddEntryTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _entryController = TextEditingController();
  double _currentMoodValue = 1;
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Mood: ${_currentMoodValue.toInt()}'),
              Slider(
                value: _currentMoodValue,
                min: 1,
                max: 5,
                divisions: 4,
                label: _currentMoodValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentMoodValue = value;
                  });
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Generate a title based on the entry text
                    },
                    icon: const Icon(CupertinoIcons.sparkles),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: TextFormField(
                  maxLines: null,
                  controller: _entryController,
                  decoration: const InputDecoration(
                    labelText: 'Entry',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an entry';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _submitForm();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    // Create a MoodEntry object with the entered data
    MoodEntry newEntry = MoodEntry(
      mood: _currentMoodValue.toInt(),
      title: _titleController.text,
      notes: _entryController.text,
      timestamp: DateTime.now(),
    );

    try {
      // Insert the MoodEntry into the database
      await DatabaseHelper().insertMoodEntry(newEntry);
      _currentMoodValue = 1;
      _titleController.clear();
      _entryController.clear();

      // Update the UI to show success message
      setState(() {
        _isSuccess = true;
      });
     Fluttertoast.showToast(msg: "Entry Added");
      CherryToast.success(

          title:  Text("Entry Added", style: TextStyle(color: Colors.black))

      ).show(context);
    } catch (error) {
      // Handle any errors that occur during database insertion
      print('Error inserting entry: $error');
      // Optionally, you can show an error message to the user
    } finally {
      // Update the UI to hide the loader
      setState(() {
        _isLoading = false;
      });
    }
  }
    // Insert the MoodEntry into the database


  @override
  void dispose() {
    _titleController.dispose();
    _entryController.dispose();
    super.dispose();
  }
}
