import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/mood_entry.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If _database is null, instantiate it
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'mood_database.db');

    // Open the database
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create the MoodEntry table
        await db.execute('''
          CREATE TABLE mood_entries(
            id INTEGER PRIMARY KEY,
            mood INTEGER,
            title TEXT,
            notes TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertMoodEntry(MoodEntry entry) async {
    final Database db = await database;

    // Insert the MoodEntry into the correct table
    await db.insert(
      'mood_entries',
      entry.toMapDbString(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MoodEntry>> getAllMoodEntries() async {
    final Database db = await database;

    // Query the table for all MoodEntries
    final List<Map<String, dynamic>> maps = await db.query('mood_entries');

    // Convert the List<Map<String, dynamic>> to a List<MoodEntry>
    return List.generate(maps.length, (i) {
      return MoodEntry.fromMap(maps[i]);
    });
  }
  Future<void> updateMoodEntry(MoodEntry entry) async {
    final Database db = await database;

    // Update the MoodEntry in the correct table
    await db.update(
      'mood_entries',
      entry.toMapDbString(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteMoodEntry(int id) async {
    final Database db = await database;

    // Delete the MoodEntry from the correct table
    await db.delete(
      'mood_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
