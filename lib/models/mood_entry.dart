import 'dart:convert';

class MoodEntry {
  final int? id; // Unique identifier for each mood entry
  final int mood; // Mood rating from 1 to 5
  final String? title; // Optional title for the mood entry
  final String? notes; // Optional mood text
  final DateTime timestamp; // Timestamp for when the mood entry was created

  MoodEntry({
    this.id,
    required this.mood,
    this.title,
    this.notes,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'title': title,
      'notes': notes,
      'timestamp': timestamp
    };
  }

  Map<String, dynamic> toMapDbString() {
    return {
      'id': id,
      'mood': mood,
      'title': title,
      'notes': notes,
      'timestamp': timestamp.toIso8601String()
    };
  }

  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id']?.toInt() ?? 0,
      mood: map['mood'].toInt(),
      title: map['title'],
      notes: map['notes'],
      timestamp: DateTime.parse(map['timestamp'])
    );
  }

  String toJson() => json.encode(toMap());

  factory MoodEntry.fromJson(String source) => MoodEntry.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MoodEntry(id: $id, mood: $mood, title: $title, notes: $notes, timestamp: $timestamp)';
  }
}
