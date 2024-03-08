import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorder {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'recording.mp4';
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;

  AudioRecorder() {
    openTheRecorder().then((value) {
      _mRecorderIsInited = true;
    });
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
      throw RecordingPermissionException('Microphone permission not granted');
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

  void record() {
    _mRecorder!.startRecorder(
      toFile: _mPath,
      codec: _codec,
    );
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder();
  }
}
