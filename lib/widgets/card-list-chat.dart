// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:premiere/constants/ArgonColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premiere/screens/Chat/ChatPage.dart';
// import 'package:argon_flutter/constants/Theme.dart';

class CardListChat extends StatelessWidget {
  CardListChat({
    this.picture = 'assets/img/profile-avatar.jpg',
    this.name = 'Adelaide',
    this.recent_msg = 'Je me suis limité à la partie',
    this.etat = 0,
    this.date,
    this.unRead = 0,
    this.type,
    this.tap = defaultFunc,
    this.onMessage = defaultFunc,
  });

  final String picture;
  final String name;
  final String recent_msg;
  final int etat;
  final String date;
  final int unRead;
  final int type;
  final tap;
  final onMessage;

  static void defaultFunc() {
    print("the function works!");
  }

  String mes = 'effectivement je suis entrainn de';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
      margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.125,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.10,
            padding: EdgeInsets.only(bottom: 5.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: tap,
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.7,
                        fit: BoxFit.cover,
                        imageUrl: picture,
                        progressIndicatorBuilder: (context, url, downloadProgress) => 
                          SpinKitWave(
                            color: Colors.white,
                            size: 15,
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
                GestureDetector(
                  onTap: onMessage,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: EdgeInsets.only(left: 5.0,),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              date != null
                              ? Text(
                                  date != ''
                                  ? DateFormat('yyyy-mm-dd kk:mm')
                                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(date)))
                                  : '',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : Container(),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                child: Row(
                                  children: [
                                    if (etat != 4)
                                      Icon(
                                        (etat == 0)
                                            ? Icons.watch
                                            : (etat == 1)
                                                ? Icons.messenger_outline
                                                : (etat == 2)
                                                    ? Icons.messenger_sharp
                                                    : (etat == 3)
                                                        ? Icons.message
                                                        : null,
                                        color: Colors.blue,
                                        size: 15,
                                      ),
                                    if(recent_msg != '')
                                      Icon(
                                        (unRead != 0)
                                          ? Icons.mark_chat_unread
                                          : Icons.mark_chat_read,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    type != null
                                    ? type == 0
                                      ? Material(
                                        child: Text(
                                          recent_msg != '' 
                                          ? recent_msg.length >= 31
                                            ? recent_msg.substring(0, 30) + '...' : recent_msg
                                          : 'Aucun message',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                      : Material(
                                          child: Row(
                                            children: [
                                              Icon(Icons.mic_sharp),
                                              Text('Audio'),
                                            ]
                                          ),
                                        )
                                    : Container(),
                                  ],
                                ),
                              ),
                              unRead != 0
                                  ? Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        unRead.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 8.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.blue,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     Colors.blueAccent,
        //     Colors.blueAccent,
        //   ],
        // )
        // color: Colors.accents,
        // border: Border(
        //   bottom: BorderSide(
        //     color: Colors.blueAccent,
        //   ),
        // )
      ),
    );
  }
}
// ListTile(
//   title: Text(name),
//   subtitle: Text(recent_msg),
  // leading: Container(
  //   width: 50.0,
  //   height: 50,
  //   decoration: BoxDecoration(
  //     borderRadius: BorderRadius.all(
  //       Radius.circular(15.0),
  //     ),
  //     image: DecorationImage(
  //       image: AssetImage(picture),
  //     ),
  //   ),
  // ),
//   // title: Text(item.name),
//   trailing: Text(date),
// ),