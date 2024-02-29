import 'dart:convert';

class JournalEntry {
  final int? id; // Unique identifier for each mood entry
  final int mood; // Mood rating from 1 to 5
  final String? title; // Optional title for the mood entry
  final String? entry; // Optional mood text
  final DateTime date; // Timestamp for when the mood entry was created

  JournalEntry({
    this.id,
    required this.mood,
    this.title,
    this.entry,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'title': title,
      'notes': entry,
      'timestamp': date
    };
  }

  Map<String, dynamic> toMapDbString() {
    return {
      'id': id,
      'mood': mood,
      'title': title,
      'notes': entry,
      'timestamp': date.toIso8601String()
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
        id: map['id']?.toInt() ?? 0,
        mood: map['mood'].toInt(),
        title: map['title'],
        entry: map['notes'],
        date: DateTime.parse(map['timestamp'])
    );
  }

  String toJson() => json.encode(toMap());

  factory JournalEntry.fromJson(String source) => JournalEntry.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MoodEntry(id: $id, mood: $mood, title: $title, notes: $entry, timestamp: $date)';
  }
}
