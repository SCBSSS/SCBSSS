import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '/services/database_service.dart';
import '../models/journal_entry.dart';

final _serverUrl = dotenv.get("BACKEND_LOC");
final _gcloudApiKey = dotenv.get("GCLOUD_API_KEY");
final _gcloudApiKey_sentiment = dotenv.get("GCLOUD_API_KEY_sentiment");

Future<String> generateTitle(String entry) async {
  final url = Uri.parse('http://$_serverUrl/title_generation');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'journal_entry': entry});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print(response.body);
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

Future<String> searchMeditationVideo() async {
  // get the 5 most recent entries from the DB
  List<JournalEntry> entries = await DatabaseService.instance.getLatestJournalEntries(5);

  if (entries.isEmpty) {
    throw Exception('No entries provided');
  }

  // count # of times each word is said
  var wordCounts = <String, int>{};
  for (var journalEntry in entries) {
    var words = journalEntry.entry?.split(' ');
    for (var word in words!) {
      wordCounts[word] = (wordCounts[word] ?? 0) + 1;
    }
  }

  // get top 5 most used words
  var sortedWords = wordCounts.keys.toList()
    ..sort((a, b) => wordCounts[b]!.compareTo(wordCounts[a]!));
  var mostFrequentWords = sortedWords.take(5).toList();

  // make the search query
  var searchQuery = "meditation ${mostFrequentWords.join(' ')}";

  // query videos on youtube
  var url = Uri.https('www.googleapis.com', '/youtube/v3/search', {
    'key': _gcloudApiKey,
    'q': searchQuery,
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

    // retrieve first video's ID
    var videoId = data['items'][0]['id']['videoId'];
    return videoId;
  } else {
    throw Exception('Failed to search videos. Status code: ${response.statusCode}');
  }
}