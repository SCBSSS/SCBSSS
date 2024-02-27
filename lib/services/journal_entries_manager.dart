import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/services/database_service.dart';

class JournalManager {
  final DatabaseService _databaseService = DatabaseService.instance;
  late List<JournalEntry> journalEntries;
  init() async {
    journalEntries = await getAllEntries();
  }


  Future<void> createEntry(JournalEntry entry) async {
    await _databaseService.insertMoodEntry(entry);
  }

  Future<void> editEntry(JournalEntry entry) async {
    // Implement the method to edit an entry in the database
  }

  Future<List<JournalEntry>> getAllEntries() async {
    return await _databaseService.getMoodEntry();
  }
}