import 'package:flutter/material.dart';

import 'package:piano/piano.dart';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'record.dart';


class KeyBoard extends StatefulWidget {
  const KeyBoard({super.key});

  @override
  State<KeyBoard> createState() => _KeyBoardState();
}


class _KeyBoardState extends State<KeyBoard> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  final FocusNode _focusNode = FocusNode();
  final recorder = Recorder();

  void _readTone(String tone) {
    assetsAudioPlayer.open(
      Audio("assets/piano-mp3/$tone.mp3")
    );
  }

  @override
  void initState(){
    super.initState();
    recorder.init();
    print("Fuck");
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    recorder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = recorder.status;
    final text = isRecording? "Record" : "Stop";
    final backgroundColor = isRecording? Colors.red : Colors.grey;

    return Scaffold(
      appBar: AppBar(
          title: const Text("Piano", style: TextStyle(color: Colors.white)),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/theme.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        backgroundColor: Colors.transparent
      ),
      body: Center(
        child: InteractivePiano(
          highlightedNotes: [
            NotePosition(note: Note.C, octave: 3)
          ],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 60,
          noteRange: NoteRange.forClefs([
            Clef.Treble,
          ]),
          onNotePositionTapped: (position) {
            String note = position.note.name;
            int octave = position.octave;
            String? accidentals;

            if(position.alternativeAccidental != null) {
              NotePosition? pos = position.alternativeAccidental;
              note = pos!.note.name;
              octave = pos.octave;
              accidentals = pos.accidental.name;
            }

            if(accidentals != null) {
              String tone = "${note}b$octave";
              _readTone(tone);
            } else {
              String tone = "$note$octave";
              _readTone(tone);
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton:  FloatingActionButton(
        onPressed: () async {
          await recorder.toggleRecording();
          setState(() {});
        },
        tooltip: text,
        backgroundColor: backgroundColor,
        child: const Icon(Icons.fiber_smart_record_sharp)
      ), 
    );
  }
}
