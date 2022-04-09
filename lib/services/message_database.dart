import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:premiere/models/chat_params.dart';
import 'package:premiere/models/message.dart';
import 'package:premiere/services/authentication.dart';

class MessageDatabaseService {

  List<Message> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _messageFromSnapshot(doc);
    }).toList();
  }

  Message _messageFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("message not found");
    return Message.fromMap(data);
  }

  // Stream<List<Map<String, dynamic>>> getMessage(String groupChatId, int limit) {
  //   List<Map<String, dynamic>> listMessage = [];
  //   Map<String, dynamic> _message;
    
  //   FirebaseFirestore.instance
  //     .collection('messages')
  //     .doc(groupChatId)
  //     .collection(groupChatId)
  //     .orderBy('timestamp', descending: true)
  //     .limit(limit).get().then((querySnapshot) {
  //       querySnapshot.docs.forEach((result) {
  //         _message = {
  //           'uid': result.data()["uid"],
  //           'idFrom': result.data()["idFrom"],
  //           'idTo': result.data()["idTo"],
  //           'timestamp': result.data()["timestamp"],
  //           'content': result.data()["content"],
  //           'type': result.data()["type"],
  //           'read': result.data()["read"],
  //         };
  //         listMessage.add(_message);
  //       });
  //     });

  //   return Stream.value(listMessage);
  // }

  Stream<List<Message>> getMessage(String groupChatId, int limit) {
    return FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots().map(_messageListFromSnapshot);
  }

  Map<String, dynamic> getLastMessage(String peer) {
    String lastMessage = '', timestamp = '', uid = '';
    String groupChatId = ChatParams(FirebaseAuth.instance.currentUser.uid, peer).getChatGroupId();
    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId).snapshots().last.asStream().map((snapshot) => 
          snapshot.docs.map((doc) {
            uid = doc.get('uid') ?? '';
            lastMessage = doc.get('content') ?? '';
            timestamp = doc.get('timestamp') ?? '';
          })  
        );
        // print(lastMessage);
    return {
      'uid': uid,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
    };
  }

  int getUnRead(String peer) {
    int unRead = 0;
    String groupChatId = ChatParams(FirebaseAuth.instance.currentUser.uid, peer).getChatGroupId();
    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .where('read', isEqualTo: true).snapshots().map((event) => {
          unRead = event.size ?? 0
        });
    return unRead;
  }
//RJJGAB7yBMSBpBsBxb9F-3sYSm5VQRReQZsiW8iMuFu3gppL2
  void onSendMessage(String groupChatId, Message message, String timestamps) {
    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(timestamps);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference,message.toHashMap());
    });
  }
}
