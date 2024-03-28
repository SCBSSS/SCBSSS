import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final _serverUrl = dotenv.get("BACKEND_LOC");

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