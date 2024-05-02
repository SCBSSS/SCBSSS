import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AudioTranscription {
  final headers = {
    'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
    'Content-Type': 'multipart/form-data',
  };

  Future<String> transcribeAudio(
      {required String audioFilePath, String? prompt}) async {
    final uri = Uri.parse('https://api.openai.com/v1/audio/transcriptions');

    // Create a multipart request
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        audioFilePath,
        contentType: MediaType('audio', 'aac'), // Assuming mp3 file
      ))
      ..fields['model'] = 'whisper-1'
      ..fields['response_format'] = "text";
    if (prompt != null) {
      request.fields["prompt"] = prompt;
    }

    var response = await request.send();

    // Handle the response
    if (response.statusCode == 200) {
      // Assuming the API returns a JSON response containing the transcription
      var responseData = await http.Response.fromStream(response);
      return responseData.body
          .trim(); // You might need to decode this, depending on the response structure
    } else {
      throw Exception(
          'Failed to transcribe audio. Status code: ${response.statusCode}');
    }
  }
}
