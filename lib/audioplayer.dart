import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioDemo extends StatefulWidget {
  const AudioDemo({Key? key}) : super(key: key);

  @override
  State<AudioDemo> createState() => _AudioDemoState();
}

class _AudioDemoState extends State<AudioDemo> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String selectedOption = 'English';
  List<String> options = ['English', 'Marathi', 'Hindi', 'Gujrati'];

  String formatTime(int seconds) {
    return '${Duration(seconds: seconds)}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  child: IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      if (isPlaying) {
                        player.pause();
                      } else {
                        player.play(AssetSource('audio/BARSANA.mp3'));
                      }
                    },
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  child: IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () {
                      player.stop();
                    },
                  ),
                ),
              ],
            ),


            Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) {
                  final position = Duration(seconds: value.toInt());
                  player.seek(position);
                  player.resume();
                }),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position.inSeconds)),
                  Text(formatTime((duration - position).inSeconds)),
                ],
              ),
            ),
            DropdownButton (
              value: selectedOption,
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 36,
              isExpanded: true,
              items: options.map((valueItems) {
                return DropdownMenuItem<String>(
                  value: valueItems,
                  child: Text(valueItems),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedOption = newValue!;
                });
              },
              hint: Text('Select an option'),
            ),
          ],
        ),
      ),
    );
  }
}
