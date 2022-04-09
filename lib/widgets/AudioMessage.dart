import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:premiere/models/message.dart';
import 'package:rxdart/rxdart.dart';

const dBlue = Colors.blue;
const dWhite = Colors.white;
const dBlack = Color(0xFF34322f);

class AudioMessage extends StatefulWidget {
  final Message message;
  final String userId;
  final bool isLastMessage;

  const AudioMessage({
    Key key,
    this.message, 
    this.userId, 
    this.isLastMessage,
  }) : super(key: key);

  @override
  _AudioMessageState createState() => _AudioMessageState(message.content);
}

class _AudioMessageState extends State<AudioMessage> {
  AudioPlayer _player;
  final String url;
  Stream<DurationState> _durationState;

  _AudioMessageState(this.url);

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        _player.positionStream,
        _player.playbackEventStream,
        (position, playbackEvent) => DurationState(
              progress: position,
              buffered: playbackEvent.bufferedPosition,
              total: playbackEvent.duration,
            ));
    _init();
  }

  Future<void> _init() async {
    print(url);
    try {
      await _player.setUrl(url);
    } catch (e) {
      print("An error occured $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: widget.userId != widget.message.idFrom
            ? const EdgeInsets.only(
                right: 25,
              )
            : const EdgeInsets.only(
                left: 20,
              ),
        decoration: widget.userId != widget.message.idFrom
            ? const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              )
            : const BoxDecoration(
                color: dBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
        child: Row(
          children: [
            Container(
              child: StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      width: 15.0,
                      height: 15.0,
                      color: widget.userId != widget.message.idFrom ? dBlue : dWhite,
                      child: CircularProgressIndicator(),
                    );
                  } else if (playing != true) {
                    return IconButton(
                      icon: Icon(Icons.play_arrow),
                      iconSize: 32.0,
                      color: widget.userId != widget.message.idFrom ? dBlue : dWhite,
                      onPressed: _player.play,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      icon: Icon(Icons.pause),
                      iconSize: 32.0,
                      color: widget.userId != widget.message.idFrom ? dBlue : dWhite,
                      onPressed: _player.pause,
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.replay),
                      iconSize: 32.0,
                      color: widget.userId != widget.message.idFrom ? dBlue : dWhite,
                      onPressed: () => _player.seek(Duration.zero),
                    );
                  }
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.60,
              child: StreamBuilder<DurationState>(
                stream: _durationState,
                builder: (context, snapshot) {
                  final durationState = snapshot.data;
                  final progress = durationState?.progress ?? Duration.zero;
                  final buffered = durationState?.buffered ?? Duration.zero;
                  final total = durationState?.total ?? Duration.zero;
                  return ProgressBar(
                    progress: progress,
                    buffered: buffered,
                    total: total,
                    progressBarColor: widget.userId != widget.message.idFrom ? dBlue : dWhite,
                    baseBarColor: widget.userId != widget.message.idFrom ? dBlue : dWhite,
                    bufferedBarColor: widget.userId != widget.message.idFrom ? dBlue : dWhite,
                    thumbColor: widget.userId != widget.message.idFrom ? dBlue : dWhite,
                    timeLabelLocation: TimeLabelLocation.sides,
                    onSeek: (duration) {
                      _player.seek(duration);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DurationState {
  const DurationState({this.progress, this.buffered, this.total});
  final Duration progress;
  final Duration buffered;
  final Duration total;
}