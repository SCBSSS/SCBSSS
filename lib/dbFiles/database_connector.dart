import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<void> createTables(sql.Database db) async {
    await db.execute(
      """CREATE TABLE users (
           id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
           username VARCHAR(64) NOT NULL UNIQUE,
           email VARCHAR(100) NOT NULL UNIQUE,
           hashed_password NOT NULL,
           join_date DATE DEFAULT CURRENT_DATE,
           preferences VARCHAR(100)
         );
         
         CREATE TABLE settings (
           settings_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
           user_id INTEGER FOREIGN KEY REFERENCES users(id),
           notification_preferences VARCHAR(100),
           app_theme VARCHAR(100),
           data_backup_options VARCHAR(100)
         );
           
         CREATE TABLE user_activity (
           activity_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
           user_id INTEGER FOREIGN KEY REFERENCES users(id),
           type VARCHAR(20),
           duration INTEGER,
           timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
           additional_details VARCHAR(500)
         );
         
         CREATE TABLE mood_entries (
           entry_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
           user_id INTEGER FOREIGN KEY REFERENCES users(id),
           timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
           mood_rating INTEGER NOT NULL,
           notes VARCHAR(500),
           related_activities INTEGER
           transcript_audio VARCHAR(500),
           transcript_txt VARCHAR(1000),
           transcript_summary VARCHAR(1000)
         );
         
         CREATE TABLE meditation (
           meditation_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
           title VARCHAR(50),
           description VARCHAR(500),
           duration INTEGER NOT NULL,
           category VARCHAR(20) NOT NULL,
           audio_file_url VARCHAR(500)
         );
      """
      );
  }
}