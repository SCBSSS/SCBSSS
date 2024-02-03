class JournalEntry {
  final int id; // Unique identifier for each journal entry
  final int mood; // Mood rating from 1 to 5
  final String? title; // Optional title for the journal entry
  final String? entry; // Optional journal text
  final DateTime date; // Timestamp for when the journal entry was created

  JournalEntry({
    required this.id,
    required this.mood,
    this.title,
    this.entry,
    required this.date,
  });
}