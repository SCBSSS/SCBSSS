import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/services/llm_services.dart';

import '../services/audio_recorder.dart';
import '../services/audio_transcription.dart';
import '../services/sentiment_analysis.dart';
import '../views/prompt_quesions_view.dart';

class AddEntryTab extends StatefulWidget {
  final void Function(JournalEntry entry, bool isnewEntry)
      createOrUpdateEntryCallback;
  final AudioRecorder _audioRecorder;
  final AudioTranscription _audioTranscription;
  final ValueNotifier<List<JournalEntry>>? journalEntries;
  final JournalEntry? existingEntry;
  final void Function()? onSubmitCallback;

  AddEntryTab(
    this.createOrUpdateEntryCallback,
    this._audioRecorder, {
    this.existingEntry,
    this.onSubmitCallback,
        this.journalEntries
  }) : _audioTranscription = AudioTranscription();

  @override
  _AddEntryTabState createState() => _AddEntryTabState(
        createOrUpdateEntryCallback,
        _audioRecorder,
        existingEntry: existingEntry,
        onSubmitCallback: onSubmitCallback,
    journalEntries: this.journalEntries
      );
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
  List<String>? promptQuestions = null;
  final ValueNotifier<List<JournalEntry>>? journalEntries;
  final void Function(JournalEntry entry, bool isnewEntry)
      createOrUpdateEntryCallback;
  final void Function()? onSubmitCallback;

  final JournalEntry? existingEntry;

  @override
  void initState() {
    super.initState();
    final existing = existingEntry;
    if (existing != null) {
      _titleController.text = existing.title ?? '';
      _entryController.text = existing.entry ?? '';
      _currentMoodValue = existingEntry!.mood.toDouble();
      _selectedMoodIndex = existingEntry!.mood - 1;
    }
  }

  void clearFields() {
    _titleController.clear();
    _entryController.clear();
    setState(() {
      _currentMoodValue = 3;
    });
  }

  void onSubmit() {
    if (existingEntry != null) {
      // Update existing entry
      existingEntry!.title = _titleController.text;
      existingEntry!.entry = _entryController.text;
      existingEntry!.mood = _currentMoodValue.toInt();
      createOrUpdateEntryCallback(existingEntry!, false);
      if (onSubmitCallback != null) {
        onSubmitCallback!();
      }
    } else {
      // Create new entry
      JournalEntry entry = JournalEntry(
        mood: _currentMoodValue.toInt(),
        title: _titleController.text,
        entry: _entryController.text,
        date: DateTime.now(),
      );
      createOrUpdateEntryCallback(entry, true);
    }
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
        String transcription = await widget._audioTranscription.transcribeAudio(
            audioFilePath: currentRecordingPath, prompt: _entryController.text);
        if (_entryController.text.endsWith(" ") ||
            _entryController.text.endsWith("\n")) {
          _entryController.text += transcription;
        } else {
          _entryController.text += ' ';
          _entryController.text += transcription;
        }
        setState(() {
          recordingState = RecordingState.ready;
        });
        if (_titleController.text.isEmpty) {
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
    var topText = (existingEntry == null)
        ? 'How are you feeling today?'
        : "Edit Entry";
    final currentPromptQuestions = promptQuestions;
    return SafeArea(
      child: SingleChildScrollView(
        // Makes the body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // Aligns the children at the start of the column
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // Stretches the children to fit the width of the column
              children: [
                if (existingEntry == null) const SizedBox(height: 16),
                // You can adjust this value if you want more or less space at the top
                Text(topText,
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
                //enrty text fiels
                TextFormField(
                  controller: _entryController,
                  keyboardType: TextInputType.multiline, //many lines
                  maxLines: existingEntry == null ? 1:10,
                  decoration: InputDecoration(
                      labelText: 'Entry',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                ),
                if (currentPromptQuestions != null)
                  PromptQuestions(questions: currentPromptQuestions),

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

  _AddEntryTabState(this.createOrUpdateEntryCallback, this._audioRecorder,
      {this.existingEntry, this.onSubmitCallback,this.journalEntries}){
    generatePromptQuestions();
  }

  detectSentiment() {
    final s = analyzeSentiment(_entryController.text);
    s.then((value) => setState(() {
          var moodval = ((value + 1) * 2.5).ceilToDouble();
          if (moodval <= 0)
            moodval = 1.0;
          else if (moodval >= 5) moodval = 5.0; //moodval NOT index
          _onEmojiSelected(
              moodval.toInt() - 1); //passing in the index NOT the moodval
        }));
  }

  generatePromptQuestions() {
    //Select past entries
    if(journalEntries == null){
      return;
    }
    final entries = journalEntries!.value;
    if(entries.length < 3){
      return;
    }
    // get last 10 entries
    final selectedEntries = entries.sublist(
        entries.length - 10 < 0 ? 0 : entries.length - 10, entries.length);
    final questions = apiGeneratePromptQuestions(
        selectedEntries.map((e) => e.entry ?? "").toList(growable: false));
    questions.then((value) => setState(() {
          promptQuestions = value;
        }));
  }

  void insertGeneratedTitle() {
    generateTitle(_entryController.text).then((value) => _titleController.text = value);
  }
}
