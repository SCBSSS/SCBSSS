import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:scbsss/models/journal_entry.dart';
import 'package:scbsss/models/setting.dart';
import 'package:scbsss/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_plan/migration/sql.dart';
import 'package:sqflite_migration_plan/sqflite_migration_plan.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();
  Database? _database;
  bool reSeed = bool.parse(dotenv.get('RE_SEED', fallback: 'false'), caseSensitive: false);
  int seedLevel = int.parse(dotenv.get('SEED_LEVEL', fallback: '1'));

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('scbsss_db.db');

    if (reSeed) {
      await seedDatabase();
    }

    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final databasesPath = await getDatabasesPath();
    final dbPath = join(databasesPath, dbName);

    if (reSeed) {
      await deleteDatabase(dbPath);
    }

    // Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}

    return await openDatabase(
      dbPath,
      version: 9,
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
          );''', reverseSql: 'DROP TABLE users;')
    ],
    2: [
      SqlMigration('''CREATE TABLE settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            user_id INTEGER,
            notification_preferences VARCHAR(100),
            app_theme VARCHAR(100),
            data_backup_options VARCHAR(100),
            FOREIGN KEY(user_id) REFERENCES users(id)
          );''', reverseSql: 'DROP TABLE settings;')
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
          );''', reverseSql: 'DROP TABLE user_activity;')
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
          );''', reverseSql: 'DROP TABLE mood_entries;')
    ],
    5: [
      SqlMigration('''CREATE TABLE meditation (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            title VARCHAR(50),
            description VARCHAR(500),
            duration INTEGER NOT NULL,
            category VARCHAR(20) NOT NULL,
            audio_file_url VARCHAR(500)
          );''', reverseSql: 'DROP TABLE meditation;')
    ],
    6: [
      SqlMigration('ALTER TABLE mood_entries RENAME TO journal_entries;',
          reverseSql: 'ALTER TABLE journal_entries RENAME TO mood_entries;')
    ],
    7: [
      SqlMigration('ALTER TABLE journal_entries RENAME COLUMN notes TO entry;',
          reverseSql:
              'ALTER TABLE journal_entries RENAME COLUMN entry TO notes;')
    ],
    8: [
      SqlMigration(
          'ALTER TABLE journal_entries RENAME COLUMN timestamp TO date;',
          reverseSql:
              'ALTER TABLE journal_entries RENAME COLUMN date TO timestamp;')
    ],
    9: [
      SqlMigration(
          'ALTER TABLE journal_entries ADD COLUMN prompt_question TEXT NULL;',
          reverseSql:
          'ALTER TABLE journal_entries DROP COLUMN prompt_question;')
    ]
  });

  Future<void> seedDatabase() async {
    print('seed | Started');

    switch (seedLevel) {
      case 1:
        await seedDatabaseLevel1();
        break;
    };

    print('seed | Finished');
    return;
  }

  Future<void> seedDatabaseLevel1() async {
    final dummyJournalEntries = [
      JournalEntry(
          mood: 1,
          title: "Academic Disappointment and Uncertainty",
          entry: "I can't believe I failed my midterm. Prof. Johnson is so unfair! I studied all night, but the questions were nothing like what we covered in class. I'm so stressed out right now. What if I lose my scholarship?",
          date: DateTime.now(),
      ),
      JournalEntry(
          mood: 4,
          title: "Sparks Fly at the Party",
          entry: "Met the most amazing guy at the party last night! His name is Alex, and he's a senior in the business school. We talked for hours, and he even asked for my number. I think I'm falling for him already!",
          date: DateTime.now(),
      ),
      JournalEntry(
          mood: 3,
          title: "Achieving My Dream Internship",
          entry: "I got the internship at the top marketing firm in the city! I can't believe it! All my hard work is finally paying off. This could be my big break. Mom and Dad will be so proud.",
          date: DateTime.now(),
    ),
      JournalEntry(
          mood: 1,
          title: "The End of a Dream",
          entry: "Alex broke up with me. He said he wasn't ready for a serious relationship. I'm devastated. How could he do this to me? I thought we had something special. I can't stop crying.",
          date: DateTime.now(),
    ),
      JournalEntry(
          mood: 3,
          title: "Struggling to Cope After Heartbreak",
          entry: "I don't know how I'm going to pass my finals. I've been so depressed since the breakup that I haven't been able to focus on studying. I'm falling behind in all my classes. What if I fail and lose everything I've worked so hard for?",
          date: DateTime.now(),
      ),
      JournalEntry(
          mood: 1,
          title: "Loss of a Loved One: Coping with the Passing of My Furry Friend",
          entry: "I'm extremely sad because my cat died today and I am in mourning.",
          date: DateTime.now(),
      ),
      JournalEntry(
          mood: 5,
          title: "Academic Relief and Family Support",
          entry: "My final exams are over and I did much better than I expected. I'm so happy to be back home with my parents. They're being very supportive and understanding of the difficulties I face this semester.",
          date: DateTime.now(),
      ),
    ];

    int i = dummyJournalEntries.length;
    int maxHour = DateTime.now().hour + 1;
    for (var journalEntry in dummyJournalEntries) {
      journalEntry.date = DateTime.now().subtract(Duration(days: i--, hours: Random().nextInt(maxHour), minutes: Random().nextInt(60)));
      sleep(const Duration(milliseconds: 10));
      await DatabaseService.instance.insertJournalEntry(journalEntry);
    }
  }

  Future<int> insertJournalEntry(JournalEntry journalEntry) async {
    final db = await instance.database;
    final insertedId =
        await db.insert('journal_entries', journalEntry.toMapDbString());

    return insertedId;
  }

  Future<List<JournalEntry>> getJournalEntry() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query('journal_entries');

    return List.generate(
        result.length, (index) => JournalEntry.fromMap(result[index]));
  }

  Future<Map<DateTime, int>> getAverageMoodByDay() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT date, round(avg(mood)) as 'mood_average' FROM (
        SELECT date(date) as 'date', mood
        FROM journal_entries
      ) GROUP BY date
    ''');

    Map<DateTime, int> returnValue = <DateTime, int> {};

    for (int i = 0; i < result.length; i++) {
      returnValue[DateTime.parse(result[i]['date'])] = result[i]['mood_average'].toInt();
    }

    return returnValue;
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

  Future<void> insertSetting(Setting setting) async {
    final db = await instance.database;

    await db.insert('settings', setting.toMapDbString());
  }

  Future<List<Setting>> getSetting() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query('setting');

    return List.generate(
        result.length, (index) => Setting.fromMap(result[index]));
  }

  Future<List<JournalEntry>> getLatestJournalEntries(int count) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query(
      'journal_entries',
      orderBy: 'date DESC',
      limit: count,
    );

    return List.generate(
      result.length,
          (index) => JournalEntry.fromMap(result[index]),
    );
  }

  Future<int> updateJournalEntry(JournalEntry journalEntry) async {
    final db = await instance.database;
    final updatedRows = await db.update(
      'journal_entries',
      journalEntry.toMapDbString(),
      where: 'id = ?',
      whereArgs: [journalEntry.id],
    );

    return updatedRows;
  }
}
