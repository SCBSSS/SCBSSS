import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scbsss/models/journal_entry.dart';

import '../services/audio_recorder.dart';
import '../services/audio_transcription.dart';

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

class _AddEntryTabState extends State<AddEntryTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _entryController = TextEditingController();
  double _currentMoodValue = 3;
  bool isRecording = false;
  final AudioRecorder _audioRecorder;
  var currentRecordingPath = "";

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

  Widget getRecordingButton() {
    Icon icon =
        isRecording ? Icon(CupertinoIcons.stop) : Icon(CupertinoIcons.waveform);
    return ElevatedButton(
      onPressed: () async {
        if (isRecording) {
          await _audioRecorder.stopRecorder();
          String transcription = await widget._audioTranscription
              .transcribeAudio(currentRecordingPath);
          _entryController.text += transcription;
        } else {
          currentRecordingPath = _audioRecorder.record();
        }
        setState(() {
          isRecording = !isRecording;
        });
      },
      child: icon,
    );
  }

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
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  _AddEntryTabState(this.createNewEntryCallback, this._audioRecorder);
}
