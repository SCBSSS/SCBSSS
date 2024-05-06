import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '/services/database_service.dart';
import '../models/journal_entry.dart';

final _serverUrl = dotenv.get("BACKEND_LOC");
final _gcloudApiKey = dotenv.get("GCLOUD_API_KEY");

Future<String> generateTitle(String entry) async {
  final url = Uri.parse('http://$_serverUrl/title_generation');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'journal_entry': entry});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final generatedTitle = responseData['summary'];
      return generatedTitle;
    } else {
      throw Exception('Failed to generate title. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error generating title: $e');
  }
}

class MeditationVideoSearcher {
  static const List<String> _stopWords = ['and', 'but', 'or', 'the', 'a', 'an', 'is', 'it', 'this', 'that'];

  Future<String> searchMeditationVideo() async {
    try {
      var entries = await _getRecentJournalEntries(5);
      if (entries.isEmpty) {
        throw Exception('No entries provided');
      }

      var searchQuery = _buildSearchQuery(entries);
      return await _fetchVideoIdFromYouTube(searchQuery);
    } catch (e) {
      throw Exception('Failed to search videos: ${e.toString()}');
    }
  }

  Future<List<JournalEntry>> _getRecentJournalEntries(int count) async {
    return DatabaseService.instance.getLatestJournalEntries(count);
  }

  String _buildSearchQuery(List<JournalEntry> entries) {
    var wordCounts = _countWords(entries);
    var sortedWords = wordCounts.keys.toList()
      ..sort((a, b) => wordCounts[b]!.compareTo(wordCounts[a]!));
    var mostFrequentWords = sortedWords.take(5).toList();
    return "meditation ${mostFrequentWords.join(' ')}";
  }

  Map<String, int> _countWords(List<JournalEntry> entries) {
    var wordCounts = <String, int>{};
    for (var entry in entries) {
      var words = entry.entry?.toLowerCase().split(RegExp(r'\W+'));
      for (var word in words!) {
        if (!_stopWords.contains(word) && word.isNotEmpty) {
          wordCounts[word] = (wordCounts[word] ?? 0) + 1;
        }
      }
    }
    return wordCounts;
  }

  Future<String> _fetchVideoIdFromYouTube(String query) async {
    var url = Uri.https('www.googleapis.com', '/youtube/v3/search', {
      'key': _gcloudApiKey,
      'q': query,
      'part': 'id,snippet',
      'maxResults': '1',
      'type': 'video',
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['items'].isEmpty) {
        throw Exception('No videos found');
      }
      return data['items'][0]['id']['videoId'];
    } else {
      throw Exception('HTTP request failed with status ${response.statusCode}');
    }
  }
}

Future<List<String>> apiGeneratePromptQuestions(List<String> entries) async {
  final apiUrl = 'http://$_serverUrl/generate_questions';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'past_entries': entries}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return List<String>.from(jsonResponse);
    } else {
      final errorResponse = json.decode(response.body);
      throw Exception('API Error: ${errorResponse['error']}');
    }
  } catch (e) {
    throw Exception('Error generating prompt questions: $e');
  }
}