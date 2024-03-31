import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/services/llm_services.dart';

import '../services/audio_recorder.dart';
import '../services/audio_transcription.dart';
import '../services/sentiment_analysis.dart';

class AddEntryTab extends StatefulWidget {
  final void Function(JournalEntry entry) createNewEntryCallback;
  final AudioRecorder _audioRecorder;
  final AudioTranscription _audioTranscription;

  AddEntryTab(this.createNewEntryCallback, this._audioRecorder)
      : _audioTranscription = AudioTranscription();

  @override
  _AddEntryTabState createState() =>
      _AddEntryTabState(createNewEntryCallback, _audioRecorder);
}

enum RecordingState {
  recording,
  transcribing,
  ready,
}

class _AddEntryTabState extends State<AddEntryTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _entryController = TextEditingController();
  final _contentController = TextEditingController();
  double _currentMoodValue = 3;
  final AudioRecorder _audioRecorder;
  var currentRecordingPath = "";
  var recordingState = RecordingState.ready;

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

  //list of emojis to choose from
  final List<String> moodEmojis = [
    '😡',
    '😢',
    '😐',
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

  Widget getRecordingButton() {
    Icon icon;
    switch (recordingState) {
      case RecordingState.recording:
        icon = Icon(CupertinoIcons.stop);
        break;
      case RecordingState.transcribing:
        icon = Icon(CupertinoIcons.time);
        break;
      case RecordingState.ready:
        icon = Icon(CupertinoIcons.waveform);
        break;
    }
    return ElevatedButton(
      onPressed: handleTranscribeButton,
      child: icon,
    );
  }

  void handleTranscribeButton() async {
      switch (recordingState) {
        case RecordingState.recording:
          await _audioRecorder.stopRecorder();
          setState(() {
            recordingState = RecordingState.transcribing;
          });
          String transcription = await widget._audioTranscription
              .transcribeAudio(
                  audioFilePath: currentRecordingPath,
                  prompt: _entryController.text);
          if(_entryController.text.endsWith(" ") || _entryController.text.endsWith("\n")) {
            _entryController.text += transcription;
          } else {
            _entryController.text += ' ';
            _entryController.text += transcription;
          }
          setState(() {
            recordingState = RecordingState.ready;
          });
          if(_titleController.text.isEmpty){
            insertGeneratedTitle();
          }
          detectSentiment();
          break;
        case RecordingState.transcribing:
          break;
        case RecordingState.ready:
          currentRecordingPath = await _audioRecorder.record();
          setState(() {
            recordingState = RecordingState.recording;
          });
          break;
      }
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
                //slider labels 1-5

                //title text field
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                      ),

                    ),
                    IconButton(
                      onPressed: insertGeneratedTitle,
                      icon: const Icon(CupertinoIcons.sparkles)
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                //entry text fields
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

              const SizedBox(height: 16),
              Row(
                children: [
                  getRecordingButton(),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: onSubmit,
                    child: Icon(CupertinoIcons.arrow_right),
                  ),
                ],
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
    _contentController.dispose();
    super.dispose();
  }

  _AddEntryTabState(this.createNewEntryCallback, this._audioRecorder);

  detectSentiment() {
    final s = analyzeSentiment(_entryController.text);
    s.then((value) => setState(() {
          var moodval = ((value + 1) * 2.5).ceilToDouble();
          if (moodval <= 0)
            moodval = 1.0;
          else if (moodval >= 5) moodval = 5.0; //moodval NOT index
          _onEmojiSelected(moodval.toInt() - 1); //passing in the index NOT the moodval
        }));
  }

  void insertGeneratedTitle() {
    generateTitle(_entryController.text).then((value) => _titleController.text = value);
  }
}
