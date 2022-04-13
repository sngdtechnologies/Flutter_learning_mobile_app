import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:premiere/services/message_database.dart';
import 'package:premiere/screens/loading.dart';
import 'package:premiere/models/chat_params.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:premiere/models/message.dart';
import 'package:premiere/screens/Chat/message_item.dart';
import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:path_provider/path_provider.dart';


const dBlue = Colors.blue;
const dWhite = Colors.white;
const dBlack = Color(0xFF34322f);
final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

/*
 * This is an example showing how to record to a Dart Stream.
 * It writes all the recorded data from a Stream to a File, which is completely stupid:
 * if an App wants to record something to a File, it must not use Streams.
 *
 * The real interest of recording to a Stream is for example to feed a
 * Speech-to-Text engine, or for processing the Live data in Dart in real time.
 *
 */

///
typedef _Fn = void Function();

/* This does not work. on Android we must have the Manifest.permission.CAPTURE_AUDIO_OUTPUT permission.
 * But this permission is _is reserved for use by system components and is not available to third-party applications._
 * Pleaser look to [this](https://developer.android.com/reference/android/media/MediaRecorder.AudioSource#VOICE_UPLINK)
 *
 * I think that the problem is because it is illegal to record a communication in many countries.
 * Probably this stands also on iOS.
 * Actually I am unable to record DOWNLINK on my Xiaomi Chinese phone.
 *
 */
//const theSource = AudioSource.voiceUpLink;
//const theSource = AudioSource.voiceDownlink;

const theSource = AudioSource.microphone;

class ChatPage extends StatefulWidget {
  const ChatPage({Key key, this.chatParams}) : super(key: key);
  final ChatParams chatParams;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String senderProfile = 'images/avatar/a6.jpg';
  final String receiverProfile = 'images/avatar/a3.jpg';

  final MessageDatabaseService messageService = MessageDatabaseService();

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _nbElement = 20;
  static const int PAGINATION_INCREMENT = 20;
  bool isLoading = false;
  bool onWrite = false;
  String namePeer = '';
  String nameUser = '';
  String profilUser = '';
  String profilPeer = '';
  int line = 1;

  Codec _codec = Codec.aacMP4;
  String _mPath;
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

  @override
  void initState() {
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });

    super.initState();
    listScrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _nbElement += PAGINATION_INCREMENT;
      });
    }
  }
  
  @override
  void dispose() {
    _mRecorder.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder.openAudioSession();
    if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = _mPath + '.webm';
      if (!await _mRecorder.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    setState(() {
      _mPath = DateTime.now().millisecondsSinceEpoch.toString() + '.mp4';
    });
    print(_codec);
    _mRecorder
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder.stopRecorder().then((value) {
      setState(() {
        //var url = value;
        _mplaybackReady = true;
      });
      uploadAudioFile();
    });
  }

// ----------------------------- UI --------------------------------------------

  _Fn getRecorderFn() {
    setState(() {
      isLoading = true;
    });
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      print('null');
      return null;
    }
    print(_mRecorder.isStopped);
    print(_mPath);
    _mRecorder.isStopped ? record() : stopRecorder();
    // return _mRecorder.isStopped ? record : stopRecorder;
  }

  @override
  Widget build(BuildContext context) {
    ProfilMessage peer = widget.chatParams.getReceiverUser();
    FirebaseFirestore.instance.collection("utilisateurs").doc(peer.nom).get().then((value){
      // print(value.data()['nom']);
      setState(() {
        namePeer = value.data()['nom'];
        profilPeer = value.data()['profil'];
      });
    });

    ProfilMessage user = widget.chatParams.getReceiverUser();
    FirebaseFirestore.instance.collection("utilisateurs").doc(user.nom).get().then((value){
      // print(value.data()['nom']);
      setState(() {
        nameUser = value.data()['nom'];
        profilUser = value.data()['profil'];
      });
    });

    return Scaffold(
      // backgroundColor: dBlue,
      // appBar: AppBar(
      //   title: Column(
      //     children: [
      //       Text(
      //         '${namePeer}',
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontSize: 15,
      //           fontWeight: FontWeight.w600,
      //         ),
      //         textAlign: TextAlign.left,
      //       ),
      //       Text(
      //         "Connectée il y a 56s",
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontSize: 13,
      //           fontWeight: FontWeight.w500,
      //         ),
      //         textAlign: TextAlign.left,
      //       ),
      //     ],),
      //   elevation: 0,
      //   backgroundColor: dBlue,
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back_ios,
      //       color: Colors.white,
      //       size: 23,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(
      //         Icons.more_vert,
      //         color: Colors.white,
      //         size: 23,
      //       ),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      drawer: ArgonDrawer(currentPage: "Chat"),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/wallpapers1.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          _chatingSection(),
        ],
      ),
    );
  }

  Widget _chatingSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          AppBar(
            title: Column(
              children: [
                Text(
                  '${namePeer}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Connectée il y a 56s",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],),
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 23,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 23,
                ),
                onPressed: () {},
              ),
            ],
          ),
          buildListMessage(),
          _bottomSection(),
          isLoading ? Loading() : Container()
        ],
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder<List<Message>>(
        stream: messageService.getMessage(widget.chatParams.getChatGroupId(), _nbElement),
        // stream: _listMessage(),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          // print(snapshot.hasData);
          if (snapshot.hasData) {
            List<Message> listMessage = snapshot.data?? List.from([]);
            // print(snapshot.data);
            // print(profilUser.profil); 
                  //Modification du document
            // _firebaseFirestore
            //     .collection('messages')
            //     .doc(widget.chatParams.getChatGroupId())
            //     .collection(widget.chatParams.getChatGroupId())
            //     .doc(listMessage[index].uid)
            //     .update({
            //       "read": true,
            //     }).then((value) {
            //       // user.reload();
            //     });
            return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  if(widget.chatParams.userUid == listMessage[index].idTo) {
                    _firebaseFirestore
                      .collection('messages')
                      .doc(widget.chatParams.getChatGroupId())
                      .collection(widget.chatParams.getChatGroupId())
                      .doc(listMessage[index].uid)
                      .update({
                        "read": true,
                      });
                  }
                  return MessageItem(
                    message: listMessage[index],
                    userId: widget.chatParams.userUid,
                    profilPeer: profilPeer,
                    profilUser: profilUser,
                    isLastMessage: isLastMessage(index, listMessage)
                  );
                },
              itemCount: listMessage.length,
              reverse: true,
              controller: listScrollController,
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _listMessage() {
    return Stream.value(
      [
        {
          'idFrom': '2',
          'idTo': '1',
          'timestamp': '1648829898375',
          'content': 'assets/audio/gospel.mp3',
          'type': 2,
        },
        {
          'idFrom': '1',
          'idTo': '2',
          'timestamp': '1648829898291',
          'content': 'Where are you going today',
          'type': 0,
        },
        {
          'idFrom': '1',
          'idTo': '2',
          'timestamp': '1648829898281',
          'content': 'Where are you going today',
          'type': 0,
        },
        {
          'idFrom': '2',
          'idTo': '1',
          'timestamp': '1648829898273',
          'content': 'images/avatar/a4.jpg',
          'type': 1,
        },
        {
          'idFrom': '2',
          'idTo': '1',
          'timestamp': '1648829898271',
          'content': 'Ooops',
          'type': 0,
        },
        {
          'idFrom': '2',
          'idTo': '1',
          'timestamp': '1648829898261',
          'content': 'Hi',
          'type': 0,
        },
        {
          'idFrom': '1',
          'idTo': '2',
          'timestamp': '1648829898251',
          'content': 'Hello',
          'type': 0,
        },    
        {
          'idFrom': '2',
          'idTo': '1',
          'timestamp': '1648829898241',
          'content': 'Coucou',
          'type': 0,
        },      
        {
          'idFrom': '2',
          'idTo': '1',
         'timestamp': '1648829898231',
          'content': 'Coucou',
          'type': 0,
        },  
        {
          'idFrom': '1',
          'idTo': '2',
          'timestamp': '1648829898131',
          'content': 'Coucou',
          'type': 0,
        },         
      ]
    );
  }

  Widget _bottomSection() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) {
                        setState(() {
                          line = 1;
                        });
                        onSendMessage(textEditingController.text, 0);
                      },
                      style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                      controller: textEditingController,
                      // expands: true,
                      maxLines: line,
                      // minLines: null,
                      cursorWidth: 3.0,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Ecrivez votre message...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (value) {
                        value.length > 1 && value.isNotEmpty
                        ? setState(() {
                            onWrite = true;
                          })
                        : setState(() {
                           onWrite = false;
                          });

                        value.length > 20 * line
                        ? setState(() {
                            line = line + 1;
                          })
                        : (value.length > 20 * line - 1) && (value.length < 20 * line)
                          ? setState(() {
                              line = line - 1;
                            })
                          : setState(() {
                              line = line;
                            });
                          
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.image),
                    onPressed: getImage,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          onWrite == false
          ? _record()
          : GestureDetector(
            onTap: () => onSendMessage(textEditingController.text, 0),
            child: Container(
              margin: const EdgeInsets.only(
                left: 5,
              ),
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _record() {
    return GestureDetector(
      onTap: () {
        print('coucou');
        getRecorderFn();
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 5,
        ),
        width: 45,
        height: 45,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            _mRecorder.isRecording ? Icons.pause : Icons.mic_none_sharp,
            color: Colors.white,
          ),
          onPressed: null,
        ),
      ),
    );
  }

  bool isLastMessage(int index, List<Message> listMessage) {
    if (index + 1 <= listMessage.length - 1) {
      if (listMessage[index].idFrom == listMessage[index + 1].idFrom) return true;
    }
    return false;
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile(pickedFile);
    }
  }

  void onSendMessage(String content, int type) {
    String times = DateTime.now().millisecondsSinceEpoch.toString();
    if (content.trim() != '') {
      messageService.onSendMessage(
          widget.chatParams.getChatGroupId(),
          Message(
            uid: times,
            idFrom: widget.chatParams.userUid,
            idTo: widget.chatParams.peer,
            timestamp: times,
            read: false,
            content: content,
            type: type),
          times,
          );
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      textEditingController.clear();
    } else {
      displaySnackBar(
              'Rien n\'a été envoyé!!!');
    }
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.blue,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future uploadFile(PickedFile file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".jpeg";
    try {
      Reference reference = FirebaseStorage.instance.ref('messages').child('images').child(fileName);
      final metadata = SettableMetadata(
          contentType: 'image/jpeg', customMetadata: {'picked-file-path': file.path});
      TaskSnapshot snapshot;
      if (kIsWeb) {
        snapshot = await reference.putData(await file.readAsBytes(), metadata);
      } else {
        snapshot = await reference.putFile(File(file.path), metadata);
      }

      String imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    } on Exception {
      setState(() {
        isLoading = false;
      });
      // Fluttertoast.showToast(msg: "Error! Try again!");
      displaySnackBar(
              'Veuillez recommencer');
    }
  }

  Future<void> uploadAudioFile() async {
    String _filePath = '/data/user/0/com.mvengi.mpremiere/cache/' + _mPath;
    String _filename = _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length);

    setState(() {
      // _isUploading = true;
    });
    try {
      Reference reference = FirebaseStorage.instance.ref('messages').child('audios').child(_filename);
      final metadata = SettableMetadata(
          contentType: 'Audio/mp4', customMetadata: {'picked-file-path': _filePath});
      print(_filePath);
      TaskSnapshot snapshot;
      snapshot = await reference.putFile(File(_filePath), metadata);

      String audioUrl = await snapshot.ref.getDownloadURL();
      // print(audioUrl);
      setState(() {
        isLoading = false;
        onSendMessage(audioUrl, 2);
      });
    } on Exception {
      setState(() {
        isLoading = false;
      });
      // Fluttertoast.showToast(msg: "Error! Try again!");
      displaySnackBar(
              'Veuillez recommencer');
    }
    // print(directory.path);
  }

}
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 15),
    //   height: double.infinity,
    //   decoration: const BoxDecoration(
    //     color: Color(0xAA34322f),
    //     borderRadius: BorderRadius.only(
    //       topRight: Radius.circular(40),
    //       topLeft: Radius.circular(40),
    //     ),
    //   ),
    //   child: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         const SizedBox(height: 45),
    //         TextMessage(
    //           message: "Months on ye at by esteem Months on ye at by esteem Months on ye at by esteem Months on ye at by esteem Months on ye at by esteem",
    //           date: "17:19",
    //           profil: senderProfile,
    //           isReceiver: 1,
    //           isDirect: 0,
    //         ),
    //         TextMessage(
    //           message: "Seen you eyes son show",
    //           date: "17:13",
    //           profil: receiverProfile,
    //           isReceiver: 0,
    //           isDirect: 0,
    //         ),
    //         TextMessage(
    //           message: "As tolerably recommend shameless",
    //           date: "17:10",
    //           profil: receiverProfile,
    //           isReceiver: 0,
    //           isDirect: 1,
    //         ),
    //         TextMessage(
    //           message: "She although cheerful perceive",
    //           date: "17:10",
    //           profil: senderProfile,
    //           isReceiver: 1,
    //           isDirect: 0,
    //         ),
    //         ImageMessage(
    //           image: 'images/avatar/a1.jpg',
    //           date: "17:09",
    //           description: "Least their she you now above going stand forth",
    //           profil: senderProfile,
    //           isReceiver: 1,
    //           isDirect: 1,
    //         ),
    //         AudioMessage(
    //           date: "18:05", 
    //           profil: senderProfile,
    //           url: 'assets/audio/gospel.mp3',
    //           isReceiver: 0,
    //           isDirect: 0,
    //         ),
    //         AudioMessage(
    //           date: "18:10", 
    //           profil: receiverProfile,
    //           url: '/data/user/0/com.mvengi.mpremiere/cache/tau_file.mp4',
    //           isReceiver: 1,
    //           isDirect: 0,
    //         ),
    //         AudioMessage(
    //           date: "18:05", 
    //           profil: senderProfile,
    //           url: '/data/user/0/com.mvengi.mpremiere/cache/tau_file1.mp4',
    //           isReceiver: 0,
    //           isDirect: 0,
    //         ),
    //         TextMessage(
    //           message: "Provided put unpacked now but bringing. ",
    //           date: "16:59",
    //           profil: senderProfile,
    //           isReceiver: 1,
    //           isDirect: 0,
    //         ),
    //         TextMessage(
    //           message: "Under as seems we me stuff",
    //           date: "16:53",
    //           profil: receiverProfile,
    //           isReceiver: 0,
    //           isDirect: 0,
    //         ),
    //         TextMessage(
    //           message: "Next it draw in draw much bred",
    //           date: "16:50",
    //           profil: receiverProfile,
    //           isReceiver: 0,
    //           isDirect: 1,
    //         ),
    //         TextMessage(
    //           message: "Sure that that way gave",
    //           date: "16:48",
    //           profil: senderProfile,
    //           isReceiver: 1,
    //           isDirect: 0,
    //         ),
    //         const SizedBox(height: 15),
    //       ],
    //     ),
    //   ),
    // );

  

 