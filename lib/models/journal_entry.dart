import 'dart:convert';

class JournalEntry {
  int? id; // Unique identifier for each journal entry
  int mood; // Mood rating from 1 to 5
  String? title; // Optional title for the mood entry
  String? entry; // Optional mood text
  DateTime date; // Timestamp for when the mood entry was created
  final String content;

  JournalEntry({
    this.id,
    required this.mood,
    this.title = '',
    this.entry = '',
    required this.date,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'title': title,
      'entry': entry,
      'date': date,
      'content': content,
    };
  }

  Map<String, dynamic> toMapDbString() {
    return {
      if (id != null) 'id': id,
      'mood': mood,
      'title': title,
      'entry': entry,
      'date': date.toIso8601String(),
      'content': content,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id']?.toInt() ?? 0,
      mood: map['mood'].toInt(),
      title: map['title'],
      entry: map['entry'],
      date: DateTime.parse(map['date']),
      content: map['content'] ?? ' ', //I think we're going to need to remove this, this is irrelevant and causes the database to not be initialized, causing an infinite loop
    );
  }

  String toJson() => json.encode(toMap());

  factory JournalEntry.fromJson(String source) =>
      JournalEntry.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JournalEntry(id: $id, mood: $mood, title: $title, entry: $entry, date: $date)';
  }
}
