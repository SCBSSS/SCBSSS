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