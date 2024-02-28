import 'package:flutter/material.dart';
import 'package:scbsss/services/database_service.dart';
import 'package:scbsss/services/journal_entries_manager.dart';
import 'package:scbsss/setup_wizard.dart';

import 'main_tab_widget.dart';
import 'models/journal_entry.dart';

class SCBSSSApp extends StatefulWidget {
  const SCBSSSApp({super.key});

  @override
  State<SCBSSSApp> createState() => _MyAppState();
}

class _MyAppState extends State<SCBSSSApp> {
  bool isSetupDone = false;
  bool isLoading = true;
  JournalManager journalManager = JournalManager();

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
    await DatabaseService.instance.database; // wait for db to get initalized
    await journalManager.init(); // wait for journal manager to get initalized

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
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // show loading indicator
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: isSetupDone
          ? MainTabWidget(createNewEntryCallback: createNewEntry, journalEntries: journalManager.journalEntries)
          : SetupWizard(completeSetup),
    );
  }
}
