import 'package:flutter/material.dart';
import 'package:scbsss/services/audio_recorder.dart';
import 'package:scbsss/services/database_service.dart';
import 'package:scbsss/services/journal_entries_manager.dart';
import 'package:scbsss/setup_wizard.dart';

import 'main_tab_widget.dart';
import 'models/journal_entry.dart';

class SCBSSSApp extends StatefulWidget {
  const SCBSSSApp({super.key});

  @override
  State<SCBSSSApp> createState() => _SCBSSSState();
}

class _SCBSSSState extends State<SCBSSSApp> {
  bool isSetupDone = false;
  bool isLoading = true;
  JournalManager journalManager = JournalManager();
  AudioRecorder audioRecorder = AudioRecorder();

  void completeSetup() {
    setState(() {
      isSetupDone = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await DatabaseService.instance.database; // wait for db to get initialized
    await journalManager.init(); // wait for journal manager to get initialized

    setState(() {
      isLoading = false; // update loading state
    });
  }

  void createNewEntry(JournalEntry entry) {
    setState(() {
      journalManager.addEntry(entry);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // show loading indicator
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: isSetupDone
          ? MainTabWidget(audioRecorder: audioRecorder, createNewEntryCallback: createNewEntry, journalEntries: journalManager.journalEntries)
          : SetupWizard(completeSetup),
    );
  }
}
