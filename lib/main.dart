import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:premiere/VeryfyConnection.dart';
import 'package:premiere/screens/Loading.dart';
import 'package:provider/provider.dart';
import 'package:premiere/services/database.dart';
import 'package:premiere/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:premiere/models/user.dart';


const dBlue = Colors.blue;
const dWhite = Colors.white;
const dBlack = Color(0xFF34322f);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      StreamProvider<AppUser>.value(
        initialData: null,
        value: AuthenticationService().user,
      ),
      StreamProvider<List<Map<String, dynamic>>>.value(
        initialData: [],
        value: DatabaseService().getStreamOfMyModel(),
      ),
    ],
    child: Premiere(),
  ));
}

class Premiere extends StatefulWidget {
  // Set default `_initialized` and `_error` state to false
  @override
  _PremiereState createState() => _PremiereState();
}

class _PremiereState extends State<Premiere> {
  bool _initialized = false;
  bool _error = false;
  User user;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Center(
        child: Text('Erreur de démarage'),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return MaterialApp(
        title: 'Mes Proff',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: Loading(),
      );
    }

    return MaterialApp(
      title: 'Mes Proff',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Colors.blue,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        primaryColor: Colors.blue,
      ),
      home: VeryfyConnection(),
      // home: user != null ? Profil() : AccueilScreen(),
    );
  }
}

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:flutter/rendering.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: HomeWidget(),
//     );
//   }
// }

// class HomeWidget extends StatefulWidget {
//   @override
//   _HomeWidgetState createState() => _HomeWidgetState();
// }

// class _HomeWidgetState extends State<HomeWidget> {
//   AudioPlayer _player;
//   final url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';
//   Stream<DurationState> _durationState;

//   @override
//   void initState() {
//     super.initState();
//     _player = AudioPlayer();
//     _durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
//         _player.positionStream,
//         _player.playbackEventStream,
//         (position, playbackEvent) => DurationState(
//               progress: position,
//               buffered: playbackEvent.bufferedPosition,
//               total: playbackEvent.duration,
//             ));
//     _init();
//   }

//   Future<void> _init() async {
//     try {
//       await _player.setUrl(url);
//     } catch (e) {
//       print("An error occured $e");
//     }
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("building app");
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             CachedNetworkImage(
//                         imageUrl: 'https://firebasestorage.googleapis.com/v0/b/exolearn-a9a0e.appspot.com/o/messages%2Fimages%2F1649358264748.jpeg?alt=media&token=a0d1bc38-31e2-49d2-9d94-7b7e9d60b98c',
//                           progressIndicatorBuilder: (context, url, downloadProgress) => 
//                                   CircularProgressIndicator(value: downloadProgress.progress),
//                           errorWidget: (context, url, error) => Container(
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   image: DecorationImage(
//                                     image: AssetImage('assets/img/img_not_available.jpeg'),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 clipBehavior: Clip.hardEdge,
//                               ),
//                       ),
//             Spacer(),
//             StreamBuilder<DurationState>(
//               stream: _durationState,
//               builder: (context, snapshot) {
//                 final durationState = snapshot.data;
//                 final progress = durationState?.progress ?? Duration.zero;
//                 final buffered = durationState?.buffered ?? Duration.zero;
//                 final total = durationState?.total ?? Duration.zero;
//                 return ProgressBar(
//                   progress: progress,
//                   buffered: buffered,
//                   total: total,
//                   timeLabelLocation: TimeLabelLocation.sides,
//                   onSeek: (duration) {
//                     _player.seek(duration);
//                   },
//                 );
//               },
//             ),
//             StreamBuilder<PlayerState>(
//               stream: _player.playerStateStream,
//               builder: (context, snapshot) {
//                 final playerState = snapshot.data;
//                 final processingState = playerState?.processingState;
//                 final playing = playerState?.playing;
//                 if (processingState == ProcessingState.loading ||
//                     processingState == ProcessingState.buffering) {
//                   return Container(
//                     margin: EdgeInsets.all(8.0),
//                     width: 32.0,
//                     height: 32.0,
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (playing != true) {
//                   return IconButton(
//                     icon: Icon(Icons.play_arrow),
//                     iconSize: 32.0,
//                     onPressed: _player.play,
//                   );
//                 } else if (processingState != ProcessingState.completed) {
//                   return IconButton(
//                     icon: Icon(Icons.pause),
//                     iconSize: 32.0,
//                     onPressed: _player.pause,
//                   );
//                 } else {
//                   return IconButton(
//                     icon: Icon(Icons.replay),
//                     iconSize: 32.0,
//                     onPressed: () => _player.seek(Duration.zero),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DurationState {
//   const DurationState({this.progress, this.buffered, this.total});
//   final Duration progress;
//   final Duration buffered;
//   final Duration total;
// }