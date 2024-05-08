import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class RecordingService {
  final recorder = AudioRecorder();
  final _uuid = Uuid();
  String? _recordingPath;

  Future<void> _initRecordingPath() async {
    if (_recordingPath == null) {
      final directory = await getTemporaryDirectory();
      _recordingPath = directory.path;
    }
  }

  Future<String?> startRecording() async {
    await _initRecordingPath();
    final filename = _genRandomFilename();
    if (await recorder.hasPermission()) {
      await recorder.start(const RecordConfig(numChannels: 1), path: filename);
      return filename;
    }
    return null;
  }

  Future<void> stopRecording() async {
    await recorder.stop();
  }

  String _genRandomFilename() {
    return "$_recordingPath/${_uuid.v4()}.mp4";
  }
}