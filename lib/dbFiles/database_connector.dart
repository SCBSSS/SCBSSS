import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_migration_plan/migration/sql.dart';
import 'package:sqflite_migration_plan/sqflite_migration_plan.dart';

class DatabaseHelper {
  static MigrationPlan migrationPlan = MigrationPlan({
    1: [
      SqlMigration(
        '''
      CREATE TABLE settings (
          settings_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          user_id INTEGER,
          notification_preferences VARCHAR(100),
          app_theme VARCHAR(100),
          data_backup_options VARCHAR(100),
          FOREIGN KEY(user_id) REFERENCES users(id)
      );

      CREATE TABLE user_activity (
          activity_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          user_id INTEGER,
          type VARCHAR(20),
          duration INTEGER,
          timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          additional_details VARCHAR(500),
          FOREIGN KEY(user_id) REFERENCES users(id)
      );

      CREATE TABLE mood_entries (
          id INTEGER PRIMARY KEY,
          mood INTEGER NOT NULL,
          title TEXT,
          entry TEXT,
          date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY(recording_id) REFERENCES recordings(id) 
      );

      CREATE TABLE recordings (
          id INTEGER PRIMARY KEY,
          audio_file_path TEXT NOT NULL,
          duration REAL NOT NULL,
          transcription TEXT
      );

      CREATE TABLE meditation (
          meditation_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          title VARCHAR(50),
          description VARCHAR(500),
          duration INTEGER NOT NULL,
          category VARCHAR(20) NOT NULL,
          audio_file_url VARCHAR(500)
      );''',
        reverseSql: '''
            DROP TABLE meditation;
            DROP TABLE mood_entries;
            DROP TABLE recordings;
            DROP TABLE user_activity;
            DROP TABLE settings;
            DROP TABLE users;
          ''',
      )
    ]
  });

  static Future<sql.Database> getDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = join(directory.path, 'scbsss_db.db');

    return sql.openDatabase(
      dbPath,
      onCreate: (db, version) {
        return migrationPlan(db, version);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        return migrationPlan(db, oldVersion, newVersion);
      },
      onDowngrade: (db, oldVersion, newVersion) {
        return migrationPlan(db, oldVersion, newVersion);
      },
      version: 1, // we will increment this whenever we make different schemas
    );
  }
}
