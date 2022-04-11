import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:premiere/screens/Loading.dart';
import 'package:premiere/services/authentication.dart';
import 'package:premiere/services/database.dart';
import 'package:premiere/services/message_database.dart';
import 'package:premiere/widgets/card-list-chat.dart';
// import 'MessageSection.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/models/ListMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'ChatPage.dart';
import 'package:premiere/models/chat_params.dart';
import 'package:premiere/models/user.dart';
import 'package:premiere/screens/Chat/ChatPage.dart';
import 'package:provider/provider.dart';

const dBlue = Colors.blue;
const dWhite = Colors.white;
const dBlack = Color(0xFF34322f);
final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IconData icon = Icons.arrow_back;
  Color white = Colors.white;
  bool click = false;
  IconData customIcon = Icons.cancel;

  bool _firstSearch = true;
  String _query = "";
  var _searchview = new TextEditingController();

  List<Map<String, dynamic>> _listMessage;
  List<Map<String, dynamic>> _filterListMessage;

  Map<String, dynamic> lastMessage;
  int unRead = 0;
  int _start = 4;
  var isLoading = false;

  _HomePageState() {
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: dBlue,
        leading: (click == false)
          ? IconButton(
              icon: Icon(icon, color: Colors.white, size: 24.0),
              onPressed: () => (icon == Icons.menu)
                  ? Scaffold.of(context).openDrawer()
                  : Navigator.pop(context))
          : Icon(
              Icons.search,
              color: Colors.white,
              size: 28,
            ),
        title: (click == false)
            ? Text("Chat")
            : ListTile(
                title: TextField(
                  controller: _searchview,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Rechercher',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon((click == false) ? Icons.search : customIcon),
            onPressed: () {
              setState(() {
                if (click == false) {
                  click = true;
                } else {
                  click = false;
                  _searchview.clear();
                }
              });
            },
          )
        ],
      ),
      drawer: ArgonDrawer(currentPage: "Chat"),
      body: Column(
        children: [
          FavoriteSection(),
          isLoading == true
          ? Loading()
          : Expanded(
              child: _firstSearch ? buildListUsers(context) : _performSearch(context),
            )
        ],
      ),
    );
  }

  getLastMessage(String peer) async {
    String groupChatId = ChatParams(FirebaseAuth.instance.currentUser.uid, peer).getChatGroupId();
    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId).get().then((querySnapshot) {
              setState(() {
                lastMessage = querySnapshot.docs.last.data();
              });
        });
  }

  getUnRead(String peer) async {
    String groupChatId = ChatParams(FirebaseAuth.instance.currentUser.uid, peer).getChatGroupId();
    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .where('read', isEqualTo: false)
        .get()
        .then((value) => 
          setState(() {
            unRead = value.size;
          })
        );
  }

  //Perform actual search
  Widget _performSearch(BuildContext context) {
    _filterListMessage = new List<Map<String, dynamic>>();
    _listMessage = Provider.of<List<Map<String, dynamic>>>(context, listen: true);
    for (int i = 0; i < _listMessage.length; i++) {
      var item = _listMessage[i];

      if (item["nom"].toLowerCase().contains(_query.toLowerCase())) {
        _filterListMessage.add(item);
      }
    }
    return _createFilteredListView(context, _filterListMessage);
  }

  //Create the list for all
  Widget buildListUsers(BuildContext context) {
    final currentUser = Provider.of<AppUser>(context, listen: true);
    // if (currentUser == null) throw Exception("Aucun utilisateur");

    final _users = Provider.of<List<Map<String, dynamic>>>(context, listen: true);
    // if (_users.length == 0) throw Exception("Aucun utilisateur");
    return ListView.builder(
      itemCount:_users.length,
      itemBuilder: (context, index) {
        // print(currentUser.uid + ' ' + _users[index]["uid"]);
        // print(_users[index]["lastMessage"]["content"]);
        var peer = _users[index]["uid"];
        var user = currentUser.uid;
        if(user == peer) return Container();
        var item = _users[index];
        
        getLastMessage(peer);
        getUnRead(peer);

        Map<String, dynamic> lastM = lastMessage;

        // const oneDecimal = const Duration(seconds: 1);
        // Timer _timer = new Timer.periodic(
        //     oneDecimal,
        //     (Timer timer) => setState(() {
        //           if (_start < 1) {
        //             timer.cancel();
        //           } else {
        //             _start = _start - 1;
        //           }
        //         }));
        // print(lastMessage["content"]);
        if(currentUser.uid != peer) {
          if(_users.length == index)
            setState(() {
              isLoading = false;
            });
          
          return CardListChat(
            etat: 4,
            unRead: unRead,
            name: item["nom"],
            picture: item["profil"],
            recent_msg: lastM["content"],    
            date: lastM["timestamp"],
            type: lastM["type"],
            tap: () => showDialog(
              context: context,
              builder: (context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.0),
                    onPressed: () => Navigator.pop(context)),
                ),
                body: Container(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: item['profil'],
                    progressIndicatorBuilder: (context, url, downloadProgress) => 
                            SpinKitWave(
                              color: Colors.white,
                              size: 20,
                            ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/img/img_not_available.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                  ),
                ),
              ),
            ),
            onMessage: (){
              if (user == peer) return;
              // Navigator.pushNamed(
              //   context,
              //   '/chat',
              //   arguments: ChatParams(user, peer),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  // return ChatScreen(
                  //   image: picture,
                  //   text: name,
                  // );
                  // return ChatPage(chatParams: ChatParams('1', '2'));
                  return ChatPage(chatParams: ChatParams(user, peer));
                }),
              );
            },
          );
        }
      }
    );
  }

  //Create the Filtered ListView
  Widget _createFilteredListView(BuildContext context, List<Map<String, dynamic>> _filterUser) {
    final currentUser = Provider.of<AppUser>(context, listen: true);
    return ListView.builder(
      itemCount:_filterUser.length,
      itemBuilder: (context, index) {
        // print(currentUser.uid + ' ' + _users[index]["uid"]);
        // print(_users[index]["lastMessage"]["content"]);
        var peer = _filterListMessage[index]["uid"];
        var user = currentUser.uid;
        if(user == peer) return Container();
        var item = _filterListMessage[index];
        
        getLastMessage(peer);
        getUnRead(peer);

        Map<String, dynamic> lastM = lastMessage;

        const oneDecimal = const Duration(seconds: 1);
        Timer _timer = new Timer.periodic(
            oneDecimal,
            (Timer timer) => setState(() {
                  if (_start < 1) {
                    timer.cancel();
                  } else {
                    _start = _start - 1;
                  }
                }));
        // print(lastMessage["content"]);
        if(currentUser.uid != peer && lastM != null) {
          return CardListChat(
            etat: 4,
            unRead: unRead,
            name: item["nom"],
            picture: item["profil"],
            recent_msg: _start < 1 ? lastM["content"] : '',    
            date: _start < 1 ? lastM["timestamp"] : null,
            type: _start < 1 ? lastM["type"] : null,
            tap: () => showDialog(
              context: context,
              builder: (context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.0),
                    onPressed: () => Navigator.pop(context)),
                ),
                body: Container(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: item['profil'],
                    progressIndicatorBuilder: (context, url, downloadProgress) => 
                            SpinKitWave(
                              color: Colors.white,
                              size: 20,
                            ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/img/img_not_available.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                  ),
                ),
              ),
            ),
            onMessage: (){
              if (user == peer) return;
              // Navigator.pushNamed(
              //   context,
              //   '/chat',
              //   arguments: ChatParams(user, peer),
              // );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  // return ChatScreen(
                  //   image: picture,
                  //   text: name,
                  // );
                  // return ChatPage(chatParams: ChatParams('1', '2'));
                  return ChatPage(chatParams: ChatParams(user, peer));
                }),
              );
            },
          );
        }
      }
    );
  }
}

class FavoriteSection extends StatelessWidget {
  FavoriteSection({Key key}) : super(key: key);

  final List favoriteContacts = [
    {
      'name': 'Alla',
      'profile': 'images/avatar/a1.jpg',
    },
    {
      'name': 'July',
      'profile': 'images/avatar/a2.jpg',
    },
    {
      'name': 'Mikle',
      'profile': 'images/avatar/a3.jpg',
    },
    {
      'name': 'Kler',
      'profile': 'images/avatar/a4.jpg',
    },
    {
      'name': 'Morelle',
      'profile': 'images/avatar/a5.jpg',
    },
    {
      'name': 'Helen',
      'profile': 'images/avatar/a6.jpg',
    },
    {
      'name': 'Steve',
      'profile': 'images/avatar/a7.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dWhite,
      child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
          color: dBlue,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Vos favories",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: favoriteContacts.map((favorite) {
                  return GestureDetector(
                    onTap: () {
                      // _firebaseFirestore
                      //   .collection('utilisateurs')
                      //   .doc(_auth.currentUser.uid)
                      //   .set({
                      //     'nom': 'Gilles Descartes',
                      //     'telephone': '651545478',
                      //     'password': '123456789',
                      //     'dateCreate': DateTime.now(),
                      //     'dateUpdate': DateTime.now(),
                      //   });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            height: 70,
                            width: 70,
                            decoration: const BoxDecoration(
                              color: dWhite,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(favorite['profile']),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            favorite['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class HomePage extends StatefulWidget {
//   HomePage({Key key, this.title = 'Path Provider'}) : super(key: key);
//   final String title;

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Future<Directory> _tempDirectory;
//   Future<Directory> _appSupportDirectory;
//   Future<Directory> _appLibraryDirectory;
//   Future<Directory> _appDocumentsDirectory;
//   Future<Directory> _externalDocumentsDirectory;
//   Future<List<Directory>> _externalStorageDirectories;
//   Future<List<Directory>> _externalCacheDirectories;

//   void _requestTempDirectory() {
//     setState(() {
//       _tempDirectory = getTemporaryDirectory();
//     });
//   }

//   Widget _buildDirectory(
//       BuildContext context, AsyncSnapshot<Directory> snapshot) {
//     Text text = const Text('');
//     if (snapshot.connectionState == ConnectionState.done) {
//       if (snapshot.hasError) {
//         text = Text('Error: ${snapshot.error}');
//       } else if (snapshot.hasData) {
//         text = Text('path: ${snapshot.data.path}');
//       } else {
//         text = const Text('path unavailable');
//       }
//     }
//     return Padding(padding: const EdgeInsets.all(16.0), child: text);
//   }

//   Widget _buildDirectories(
//       BuildContext context, AsyncSnapshot<List<Directory>> snapshot) {
//     Text text = const Text('');
//     if (snapshot.connectionState == ConnectionState.done) {
//       if (snapshot.hasError) {
//         text = Text('Error: ${snapshot.error}');
//       } else if (snapshot.hasData) {
//         final String combined =
//             snapshot.data.map((Directory d) => d.path).join(', ');
//         text = Text('paths: $combined');
//       } else {
//         text = const Text('path unavailable');
//       }
//     }
//     return Padding(padding: const EdgeInsets.all(16.0), child: text);
//   }

//   void _requestAppDocumentsDirectory() {
//     setState(() {
//       _appDocumentsDirectory = getApplicationDocumentsDirectory();
//     });
//   }

//   void _requestAppSupportDirectory() {
//     setState(() {
//       _appSupportDirectory = getApplicationSupportDirectory();
//     });
//   }

//   void _requestAppLibraryDirectory() {
//     setState(() {
//       _appLibraryDirectory = getLibraryDirectory();
//     });
//   }

//   void _requestExternalStorageDirectory() {
//     setState(() {
//       _externalDocumentsDirectory = getExternalStorageDirectory();
//     });
//   }

//   void _requestExternalStorageDirectories(StorageDirectory type) {
//     setState(() {
//       _externalStorageDirectories = getExternalStorageDirectories(type: type);
//     });
//   }

//   void _requestExternalCacheDirectories() {
//     setState(() {
//       _externalCacheDirectories = getExternalCacheDirectories();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: ListView(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 child: const Text('Get Temporary Directory'),
//                 onPressed: _requestTempDirectory,
//               ),
//             ),
//             FutureBuilder<Directory>(
//                 future: _tempDirectory, builder: _buildDirectory),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 child: const Text('Get Application Documents Directory'),
//                 onPressed: _requestAppDocumentsDirectory,
//               ),
//             ),
//             FutureBuilder<Directory>(
//                 future: _appDocumentsDirectory, builder: _buildDirectory),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 child: const Text('Get Application Support Directory'),
//                 onPressed: _requestAppSupportDirectory,
//               ),
//             ),
//             FutureBuilder<Directory>(
//                 future: _appSupportDirectory, builder: _buildDirectory),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 child: const Text('Get Application Library Directory'),
//                 onPressed: _requestAppLibraryDirectory,
//               ),
//             ),
//             FutureBuilder<Directory>(
//                 future: _appLibraryDirectory, builder: _buildDirectory),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 child: Text(
//                     '${Platform.isIOS ? "External directories are unavailable " "on iOS" : "Get External Storage Directory"}'),
//                 onPressed:
//                     Platform.isIOS ? null : _requestExternalStorageDirectory,
//               ),
//             ),
//             FutureBuilder<Directory>(
//                 future: _externalDocumentsDirectory, builder: _buildDirectory),
//             Column(children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton(
//                   child: Text(
//                       '${Platform.isIOS ? "External directories are unavailable " "on iOS" : "Get External Storage Directories"}'),
//                   onPressed: Platform.isIOS
//                       ? null
//                       : () {
//                           _requestExternalStorageDirectories(
//                             StorageDirectory.music,
//                           );
//                         },
//                 ),
//               ),
//             ]),
//             FutureBuilder<List<Directory>>(
//                 future: _externalStorageDirectories,
//                 builder: _buildDirectories),
//             Column(children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton(
//                   child: Text(
//                       '${Platform.isIOS ? "External directories are unavailable " "on iOS" : "Get External Cache Directories"}'),
//                   onPressed:
//                       Platform.isIOS ? null : _requestExternalCacheDirectories,
//                 ),
//               ),
//             ]),
//             FutureBuilder<List<Directory>>(
//                 future: _externalCacheDirectories, builder: _buildDirectories),
//           ],
//         ),
//       ),
//     );
//   }
// }