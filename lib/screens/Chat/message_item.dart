import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:premiere/models/message.dart';
import 'package:premiere/screens/loading.dart';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:premiere/widgets/AudioMessage.dart';
import 'package:rxdart/rxdart.dart';

const dBlue = Colors.blue;
const dWhite = Colors.white;
const dBlack = Color(0xFF34322f);

class MessageItem extends StatelessWidget {
  final Message message;
  final String userId;
  final bool isLastMessage;
  final String profilPeer;
  final String profilUser;

  MessageItem(
      {Key key, this.message, this.userId, this.isLastMessage, this.profilPeer, this.profilUser});

  @override
  Widget build(BuildContext context) {
    // print('content' + message.content);
    return Column(
      crossAxisAlignment:
          userId == message.idFrom ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        !isLastMessage == true
        ? Column(
            children: [
              Row(
                mainAxisAlignment: 
                  userId != message.idFrom 
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width * 0.17,
                        height: MediaQuery.of(context).size.height * 0.1,
                        fit: BoxFit.cover,
                        imageUrl: userId == message.idFrom ? profilUser : profilPeer,
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
                    // child: CachedNetworkImage(
                    //   width: 60,
                    //   height: 50,
                    //   fit: BoxFit.cover,
                    //   imageUrl: userId == message.idFrom ? profilUser : profilPeer,
                    //   progressIndicatorBuilder: (context, url, downloadProgress) => 
                    //     SpinKitWave(
                    //       color: Colors.white,
                    //       size: 20,
                    //     ),
                    //   errorWidget: (context, url, error) => Container(
                    //     decoration: BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       image: DecorationImage(
                    //         image: AssetImage('assets/img/img_not_available.jpeg'),
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //     clipBehavior: Clip.hardEdge,
                    //   ),
                    // ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          )
          : SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment:
                userId == message.idFrom ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              message.type == 0 
              ? messageContainer() 
              : message.type == 1 
                  ? imageContainer(context)
                  : audioContainer(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        Row(
          mainAxisAlignment: 
            userId != message.idFrom
            ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            Icon(
                Icons.check,
                color: userId != message.idFrom ? dBlue : dWhite,
                size: 13.0,
              ),
              const SizedBox(
                width: 7.0,
              ),
              Text(
                DateFormat('dd MMM kk:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(message.timestamp))),
                style: TextStyle(
                  color: userId != message.idFrom ? dBlue : dWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              )
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget messageContainer() {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        margin: userId != message.idFrom
            ? const EdgeInsets.only(
                right: 35,
              )
            : const EdgeInsets.only(
                left: 30,
              ),
        padding: const EdgeInsets.all(15),
        decoration: userId != message.idFrom 
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
        child: Text(
          message.content,
          style: TextStyle(
            color: userId != message.idFrom ? dBlue : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget imageContainer(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
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
              imageUrl: message.content,
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
      child: Material(
        borderRadius: 
          userId == message.idFrom
          ? BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            )
          : BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
        child: CachedNetworkImage(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.3,
          fit: BoxFit.cover,
          imageUrl: message.content,
          progressIndicatorBuilder: (context, url, downloadProgress) => 
                  CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => Material(
              child: Image.asset(
                'assets/img/img_not_available.jpeg',
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
              ),
              borderRadius: 
                userId == message.idFrom
                ? BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
              clipBehavior: Clip.hardEdge,
            ),
        ),
        clipBehavior: Clip.hardEdge,
      ),
    );
  }

  Widget audioContainer() {
    return AudioMessage(
      message: message,
      userId: userId,
      isLastMessage: isLastMessage,
    );
  }
}