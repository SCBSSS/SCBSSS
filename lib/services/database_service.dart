import 'dart:io';
import 'package:path/path.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_plan/migration/sql.dart';
import 'package:sqflite_migration_plan/sqflite_migration_plan.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('scbsss_db.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, dbName);


    // Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}

    return await openDatabase(
      dbPath,
      version: 8,
      onCreate: (db, version) {
        return migrationPlan(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        return migrationPlan(db, oldVersion, newVersion);
      },
      onDowngrade: (db, oldVersion, newVersion) {
        return migrationPlan(db, oldVersion, newVersion);
      },
    );
  }

  static MigrationPlan migrationPlan = MigrationPlan({
      1: [
        SqlMigration('''CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            username VARCHAR(64) NOT NULL UNIQUE,
            email VARCHAR(100) NOT NULL UNIQUE,
            hashed_password NOT NULL,
            join_date DATE DEFAULT CURRENT_DATE,
            preferences VARCHAR(100)
          );''',
          reverseSql: 'DROP TABLE users;'
        )
      ],
      2: [
        SqlMigration('''CREATE TABLE settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            user_id INTEGER,
            notification_preferences VARCHAR(100),
            app_theme VARCHAR(100),
            data_backup_options VARCHAR(100),
            FOREIGN KEY(user_id) REFERENCES users(id)
          );''',
          reverseSql: 'DROP TABLE settings;'
        )
      ],
      3: [
        SqlMigration('''CREATE TABLE user_activity (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            user_id INTEGER,
            type VARCHAR(20),
            duration INTEGER,
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            additional_details VARCHAR(500),
            FOREIGN KEY(user_id) REFERENCES users(id)
          );''',
          reverseSql: 'DROP TABLE user_activity;'
        )
      ],
      4: [
        SqlMigration('''CREATE TABLE mood_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            user_id INTEGER,
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            mood INTEGER NOT NULL,
            title VARCHAR(500),
            notes VARCHAR(500),
            FOREIGN KEY(user_id) REFERENCES users(id)
          );''',
          reverseSql: 'DROP TABLE mood_entries;'
        )
      ],
      5: [
        SqlMigration('''CREATE TABLE meditation (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            title VARCHAR(50),
            description VARCHAR(500),
            duration INTEGER NOT NULL,
            category VARCHAR(20) NOT NULL,
            audio_file_url VARCHAR(500)
          );''',
          reverseSql: 'DROP TABLE meditation;'
        )
      ],
      6: [
        SqlMigration('ALTER TABLE mood_entries RENAME TO journal_entries;',
          reverseSql: 'ALTER TABLE journal_entries RENAME TO mood_entries;'
        )
      ],
      7: [
        SqlMigration('ALTER TABLE journal_entries RENAME COLUMN notes TO entry;',
          reverseSql: 'ALTER TABLE journal_entries RENAME COLUMN entry TO notes;'
        )
      ],
      8: [
        SqlMigration('ALTER TABLE journal_entries RENAME COLUMN timestamp TO date;',
          reverseSql: 'ALTER TABLE journal_entries RENAME COLUMN date TO timestamp;'
        )
      ],
    });

  Future<void> insertMoodEntry(JournalEntry journalEntry) async {
    final db = await instance.database;

    await db.insert('journal_entries', journalEntry.toMapDbString());
  }

  Future<List<JournalEntry>> getMoodEntry() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query('journal_entries');

    return List.generate(result.length, (index) => JournalEntry.fromMap(result[index]));
  }

  Future<void> insertUser(User user) async {
    final db = await instance.database;

    await db.insert('users', user.toMapDbString());
  }

  Future<List<User>> getUser() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query('users');

    return List.generate(result.length, (index) => User.fromMap(result[index]));
  }
}
