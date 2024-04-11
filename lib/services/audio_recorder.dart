import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class AudioRecorder {
  Codec _codec = Codec.aacMP4;
  late final String recordingPath;
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;
  var _uuid = Uuid();

  AudioRecorder() {
    openTheRecorder().then((value) async {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}';
      recordingPath = filePath;
      _mRecorderIsInited = true;
    });
  }
  String genRandomFilename() {
    return "$recordingPath/${_uuid.v4()}.mp4";
  }

  void dispose() {
    _mRecorder!.closeRecorder();
    _mRecorder = null;
  }

  Future<void> openTheRecorder() async {
    print("Requesting perms");
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print("Status: $status");
      // throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder!.openRecorder();

    final session = await AudioSession.instance;

    final configuration = AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.record,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers |
          AVAudioSessionCategoryOptions.allowBluetooth,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        usage: AndroidAudioUsage.voiceCommunication,
        flags: AndroidAudioFlags.none,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransient,
      androidWillPauseWhenDucked: true,
    );

    await session.configure(configuration);

    _mRecorderIsInited = true;
  }

  String record() {
    var filename = genRandomFilename();
    _mRecorder!.startRecorder(
      toFile: filename,
      codec: _codec,
    );
    return filename;
  }

  Future<String?> stopRecorder() async {
    return await _mRecorder!.stopRecorder();
  }
}
