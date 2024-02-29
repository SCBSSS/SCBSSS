import 'package:flutter/foundation.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/services/database_service.dart';

class JournalManager {
  final DatabaseService _databaseService = DatabaseService.instance;
  final ValueNotifier<List<JournalEntry>> _journalEntries = ValueNotifier<List<JournalEntry>>([]);

  Future<void> init() async {
    _journalEntries.value = await _databaseService.getJournalEntry();
  }

  ValueNotifier<List<JournalEntry>> get journalEntries => _journalEntries;

  Future<void> addEntry(JournalEntry entry) async {
    _journalEntries.value = List.from(_journalEntries.value)..add(entry);
    _databaseService.insertJournalEntry(entry);
  }
}
