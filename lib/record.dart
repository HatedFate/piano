import 'package:flutter_sound/flutter_sound.dart';

import 'package:permission_handler/permission_handler.dart';

const path = 'test.aac';


class Recorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _recorderInitialised = false;

  bool get status => _recorderInitialised;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if(status == PermissionStatus.denied) {
      throw RecordingPermissionException("Permission Denied!");
    }
    await _audioRecorder!.openRecorder();
    _recorderInitialised = true;
  }

  void dispose() {
    if(!_recorderInitialised) return;
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _recorderInitialised = false;
  }

  Future _record() async {
    await _audioRecorder!.startRecorder(toFile: path);
  }

  Future _stop() async {
    if(!_recorderInitialised) return;
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}

