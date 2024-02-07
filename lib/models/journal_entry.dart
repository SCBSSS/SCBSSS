class JournalEntry {
  final int id; // Unique identifier for each journal entry
  final int mood; // Mood rating from 1 to 5
  final String title; // Optional title for the journal entry
  final String entry; // Optional journal text
  final DateTime? date; // Timestamp for when the journal entry was created

  JournalEntry({
    required this.id,
    required this.mood,
    required this.title,
    required this.entry,
    required this.date,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      mood: map['mood'],
      title: map['title'],
      entry: map['entry'],
      date: DateTime.tryParse(map['date'])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'title': title,
      'entry': entry,
      'date': date
    };
  }
}
