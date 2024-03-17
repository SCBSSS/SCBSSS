import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';

class AddEntryTab extends StatefulWidget {
  final void Function(JournalEntry entry) createNewEntryCallback;

  AddEntryTab(this.createNewEntryCallback);
  @override
  _AddEntryTabState createState() => _AddEntryTabState(createNewEntryCallback);
}

class _AddEntryTabState extends State<AddEntryTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _entryController = TextEditingController();
  double _currentMoodValue = 3;

  void Function(JournalEntry entry) createNewEntryCallback;

  void clearFields() {
    _titleController.clear();
    _entryController.clear();
    setState(() {
      _currentMoodValue = 3;
    });
  }

  void onSubmit() {
    JournalEntry entry = JournalEntry(
        mood: _currentMoodValue.toInt(),
        title: _titleController.text,
        entry: _entryController.text,
        date: DateTime.now());
    createNewEntryCallback(entry);
    clearFields();
  }

  //list of emjois to choose from
  final List<String> moodEmojis = [
    '😡',
    '😢 ',
    '😑',
    '😊',
    '😁',
  ];
  int _selectedMoodIndex = 2; //default mood index

  //update emoji selection
  void _onEmojiSelected(int index) {
    setState(() {
      _selectedMoodIndex = index;
      _currentMoodValue = (index + 1).toDouble(); //mood value 1-5
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensures the scaffold resizes when the keyboard appears
      appBar: AppBar(
          //removed "add entry" to keep it more clean and simple
          ),
      body: SingleChildScrollView(
        // Makes the body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .start, // Aligns the children at the start of the column
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // Stretches the children to fit the width of the column
              children: [
                const SizedBox(
                    height:
                        16), // You can adjust this value if you want more or less space at the top
                const Text(
                  'Hi! \nHow are you feeling today?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(moodEmojis.length, (index) {
                    return GestureDetector(
                      onTap: () => _onEmojiSelected(index),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: _selectedMoodIndex == index
                              ? Colors.blue[100]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          moodEmojis[index],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 8), //space after emoji

                //adding back the slider // Slider
                Slider(
                  value: _currentMoodValue,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: moodEmojis[_currentMoodValue.toInt() - 1],
                  onChanged: (double value) {
                    setState(() {
                      _currentMoodValue = value;
                      _selectedMoodIndex = value.toInt() - 1; //update emoji
                    });
                  },
                ),
                //slider labels 1-5
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      return Text(
                        (index + 1).toString(), //1 through 5
                        style: TextStyle(fontSize: 16),
                      );
                    })),

                //title text field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                ),

                //enrty text fiels
                TextFormField(
                  controller: _entryController,
                  maxLines: 10, //larger
                  keyboardType: TextInputType.multiline, //many lines
                  decoration: InputDecoration(
                      labelText: 'Entry',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                ),

                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text('Submit'),
                ),
              ],
            ),
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

  _AddEntryTabState(this.createNewEntryCallback);
}
