 import 'package:flutter/widgets.dart';

class Message {
  final String uid;
  final String idFrom;
  final String idTo;
  final String timestamp;
  final String content;

  // type: 0 = text, 1 = image
  final int type;
  final bool read;

  Message(
      { 
      this.uid,
      this.idFrom,
      this.idTo,
      this.timestamp,
      this.content,
      this.type, 
      this.read});

   Map<String, dynamic> toHashMap() {
    return {
      'uid': uid,
      'idFrom': idFrom,
      'idTo': idTo,
      'timestamp': timestamp,
      'content': content,
      'type': type,
      'read': read
    };
  }

  factory Message.fromMap(Map<String, dynamic> data){
    return Message(
      uid: data["uid"],
      idFrom: data['idFrom'],
      idTo: data['idTo'],
      timestamp: data['timestamp'],
      content: data['content'],
      type: data['type'],
      read: data["read"]
    );
  } 
}