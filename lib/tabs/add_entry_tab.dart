import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEntryTab extends StatefulWidget {
  @override
  _AddEntryTabState createState() => _AddEntryTabState();
}

class _AddEntryTabState extends State<AddEntryTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _entryController = TextEditingController();
  double _currentMoodValue = 1;

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
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.sparkles),
                  ) // TODO: Generate a title based on the entry text
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
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _entryController.dispose();
    super.dispose();
  }
}
