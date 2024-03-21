import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<double> analyzeSentiment(String input) async {
  final String apiKey = dotenv.get('GCLOUD_API_KEY');
  final String apiUrl =
      'https://language.googleapis.com/v1/documents:analyzeSentiment?key=$apiKey';

  final Map<String, dynamic> requestBody = {
    'encodingType': 'UTF8',
    'document': {
      'type': 'PLAIN_TEXT',
      'content': input,
    },
  };

  final http.Response response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData.toString());
    final double sentimentScore = responseData['documentSentiment']['score'];
    return sentimentScore;
  } else {
    throw Exception('Failed to analyze sentiment. Status code: ${response.statusCode}');
  }
}