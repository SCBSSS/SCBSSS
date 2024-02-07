import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('scbsss.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, dbName);

    // Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}

    databaseFactory.deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: _createDB, onConfigure: onConfigure);
  }

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    var batch = db.batch();

    _createTableJournalEntryV1(batch);
    _seedTableJournalEntry(batch);

    await batch.commit();
  }

  void _createTableJournalEntryV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS Journal_Entry');
    batch.execute('''CREATE TABLE Journal_Entry (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      mood INTEGER,
      title TEXT,
      entry TEXT,
      date DATETIME
    )''');
  }

  void _seedTableJournalEntry(Batch batch) {
    batch.execute('''INSERT INTO Journal_Entry (
        mood,
        title,
        entry,
        date
      )
      VALUES (
        '1',
        'Day 1 of classes',
        'Classes went well',
        '${DateTime.now()}'
      ),
      (
        '3',
        'Day 2 of classes',
        'Classes were okay',
        '${DateTime.now()}'
      ),
      (
        '5',
        'Day 3 of classes',
        'Classes were excellent',
        '${DateTime.now()}'
      ),
      (
        '2',
        'Day 4 of classes',
        'Classes were not so good',
        '${DateTime.now()}'
      ),
      (
        '4',
        'Day 5 of classes',
        'Classes were good',
        '${DateTime.now()}'
      )
    ''');
  }

  Future<void> insert({required JournalEntry journalEntry}) async {
    try {
      final db = await database;

      db.insert('Journal_Entry', journalEntry.toMap());
    } catch (error) {
      print(error.toString());
    };
  }

  Future<List<JournalEntry>> getAllJournalEntries() async {
    final db = await instance.database;

    final result = await db.query('Journal_Entry');

    return result.map((json) => JournalEntry.fromJson(json)).toList();
  }
}

