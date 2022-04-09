
// import 'dart:async';
// import 'dart:io';
// import 'package:audio_session/audio_session.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
// import 'package:premiere/models/message.dart';

// /*
//  * This is an example showing how to record to a Dart Stream.
//  * It writes all the recorded data from a Stream to a File, which is completely stupid:
//  * if an App wants to record something to a File, it must not use Streams.
//  *
//  * The real interest of recording to a Stream is for example to feed a
//  * Speech-to-Text engine, or for processing the Live data in Dart in real time.
//  *
//  */

// ///
// typedef _Fn = void Function();

// /* This does not work. on Android we must have the Manifest.permission.CAPTURE_AUDIO_OUTPUT permission.
//  * But this permission is _is reserved for use by system components and is not available to third-party applications._
//  * Pleaser look to [this](https://developer.android.com/reference/android/media/MediaRecorder.AudioSource#VOICE_UPLINK)
//  *
//  * I think that the problem is because it is illegal to record a communication in many countries.
//  * Probably this stands also on iOS.
//  * Actually I am unable to record DOWNLINK on my Xiaomi Chinese phone.
//  *
//  */
// //const theSource = AudioSource.voiceUpLink;
// //const theSource = AudioSource.voiceDownlink;

// const theSource = AudioSource.microphone;

// /// Example app.
// class Record extends StatefulWidget {
//   @override
//   _RecordState createState() => _RecordState();
// }

// class _RecordState extends State<Record> {
//   Codec _codec = Codec.aacMP4;
//   String _mPath = DateTime.now().millisecondsSinceEpoch.toString() + '.mp4';
//   FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
//   FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
//   bool _mPlayerIsInited = false;
//   bool _mRecorderIsInited = false;
//   bool _mplaybackReady = false;

//   @override
//   void initState() {
//     _mPlayer.openAudioSession().then((value) {
//       setState(() {
//         _mPlayerIsInited = true;
//       });
//     });

//     openTheRecorder().then((value) {
//       setState(() {
//         _mRecorderIsInited = true;
//       });
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _mPlayer.closeAudioSession();
//     _mPlayer = null;

//     _mRecorder.closeAudioSession();
//     _mRecorder = null;
//     super.dispose();
//   }

//   Future<void> openTheRecorder() async {
//     // if (!kIsWeb) {
//     //   var status = await Permission.microphone.request();
//     //   if (status != PermissionStatus.granted) {
//     //     throw RecordingPermissionException('Microphone permission not granted');
//     //   }
//     // }
//     await _mRecorder.openAudioSession();
//     if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
//       _codec = Codec.opusWebM;
//       _mPath = 'tau_file1.webm';
//       if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
//         _mRecorderIsInited = true;
//         return;
//       }
//     }
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration(
//       avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
//       avAudioSessionCategoryOptions:
//           AVAudioSessionCategoryOptions.allowBluetooth |
//               AVAudioSessionCategoryOptions.defaultToSpeaker,
//       avAudioSessionMode: AVAudioSessionMode.spokenAudio,
//       avAudioSessionRouteSharingPolicy:
//           AVAudioSessionRouteSharingPolicy.defaultPolicy,
//       avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
//       androidAudioAttributes: const AndroidAudioAttributes(
//         contentType: AndroidAudioContentType.speech,
//         flags: AndroidAudioFlags.none,
//         usage: AndroidAudioUsage.voiceCommunication,
//       ),
//       androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
//       androidWillPauseWhenDucked: true,
//     ));

//     _mRecorderIsInited = true;
//   }

//   // ----------------------  Here is the code for recording and playback -------

//   void record() {
//     _mRecorder
//         .startRecorder(
//       toFile: _mPath,
//       codec: _codec,
//       audioSource: theSource,
//     )
//         .then((value) {
//       setState(() {});
//     });
//   }

//   void stopRecorder() async {
//     await _mRecorder.stopRecorder().then((value) {
//       setState(() {
//         //var url = value;
//         _mplaybackReady = true;
//       });
//     });
//   }

//   void play() {
//     assert(_mPlayerIsInited &&
//         _mplaybackReady &&
//         _mRecorder.isStopped &&
//         _mPlayer.isStopped);
//     _mPlayer
//         .startPlayer(
//             fromURI: _mPath,
//             //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
//             whenFinished: () {
//               setState(() {});
//             })
//         .then((value) {
//       setState(() {});
//     });
//   }

//   void stopPlayer() {
//     _mPlayer.stopPlayer().then((value) {
//       setState(() {});
//     });
//   }

// // ----------------------------- UI --------------------------------------------

//   _Fn getRecorderFn() {
//     if (!_mRecorderIsInited || !_mPlayer.isStopped) {
//       return null;
//     }
//     return _mRecorder.isStopped ? record : stopRecorder;
//   }

//   _Fn getPlaybackFn() {
//     if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
//       return null;
//     }
//     return _mPlayer.isStopped ? play : stopPlayer;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: getRecorderFn(),
//       child: Container(
//         margin: const EdgeInsets.only(
//           left: 5,
//         ),
//         width: 45,
//         height: 45,
//         decoration: const BoxDecoration(
//           color: Colors.blue,
//           shape: BoxShape.circle,
//         ),
//         child: IconButton(
//           icon: Icon(
//             _mRecorder.isRecording ? Icons.pause : Icons.mic_none_sharp,
//             color: Colors.white,
//           ),
//           onPressed: null,
//         ),
//       ),
//     );
//         // Container(
//         //   margin: const EdgeInsets.all(3),
//         //   padding: const EdgeInsets.all(3),
//         //   height: 80,
//         //   width: double.infinity,
//         //   alignment: Alignment.center,
//         //   decoration: BoxDecoration(
//         //     color: Color(0xFFFAF0E6),
//         //     border: Border.all(
//         //       color: Colors.indigo,
//         //       width: 3,
//         //     ),
//         //   ),
//         //   child: Row(children: [
//         //     ElevatedButton(
//         //       onPressed: getPlaybackFn(),
//         //       //color: Colors.white,
//         //       //disabledColor: Colors.grey,
//         //       child: Text(_mPlayer.isPlaying ? 'Stop' : 'Play'),
//         //     ),
//         //     SizedBox(
//         //       width: 20,
//         //     ),
//         //     Text(_mPlayer.isPlaying
//         //         ? 'Playback in progress'
//         //         : 'Player is stopped'),
//         //   ]),
//         // ),
//   }

//   void onSendMessage(String content, int type) {
//     if (content.trim() != '') {
//       messageService.onSendMessage(
//           widget.chatParams.getChatGroupId(),
//           Message(
//               idFrom: widget.chatParams.userUid,
//               idTo: widget.chatParams.peer,
//               timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
//               content: content,
//               type: type));
//       listScrollController.animateTo(0.0,
//           duration: Duration(milliseconds: 300), curve: Curves.easeOut);
//       textEditingController.clear();
//     } else {
//       displaySnackBar(
//               'Rien n\'a été envoyé!!!');
//     }
//   }

//   displaySnackBar(text) {
//     final snackBar = SnackBar(
//       content: Text(text),
//       backgroundColor: Colors.blue,
//     );
//     _scaffoldKey.currentState.showSnackBar(snackBar);
//   }
  
//   Future<void> uploadAudioFile() async {
//     String _filePath = '/data/user/0/com.mvengi.mpremiere/cache/' + _mPath;
//     String _filename = _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length);

//     setState(() {
//       // _isUploading = true;
//     });
//     try {
//       Reference reference = FirebaseStorage.instance.ref('messages').child('audios').child(_filename);
//       final metadata = SettableMetadata(
//           contentType: 'Audio/mp4', customMetadata: {'picked-file-path': _filePath});

//       TaskSnapshot snapshot;
//       snapshot = await reference.putFile(File(_filePath), metadata);

//       String audioUrl = await snapshot.ref.getDownloadURL();
//       // print(audioUrl);
//       setState(() {
//         isLoading = false;
//         onSendMessage(audioUrl, 2);
//       });
//     } on Exception {
//       setState(() {
//         isLoading = false;
//       });
//       // Fluttertoast.showToast(msg: "Error! Try again!");
//       displaySnackBar(
//               'Veuillez recommencer');
//     }
//     // print(directory.path);
//   }
// }