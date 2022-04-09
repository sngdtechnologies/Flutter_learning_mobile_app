import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:premiere/models/user.dart';

class ChatParams{
  final String userUid;
  final String peer; 

  ChatParams(this.userUid, this.peer);

  String getChatGroupId() {
    if (userUid.hashCode <= peer.hashCode) {
      return '$userUid-$peer';
    } else {
      return '$peer-$userUid';
    }
  }

  ProfilMessage getSenderUser() {
    // FirebaseFirestore.instance.collection("utilisateurs").doc(userUid).get().then((value){
      // print(value.data()['nom']);
      // return ProfilMessage(value.data()['nom'], 'images/avatar/a6.jpg');
    // });
    return ProfilMessage(userUid, 'https://firebasestorage.googleapis.com/v0/b/exolearn-a9a0e.appspot.com/o/users%2FlFtUmTNGA3ey2POxYLLuCQewyo12%2Fprofil%2F1649094197683.jpeg?alt=media&token=0d0e1593-903f-4721-9574-92d5bd01bde0');
  }

  ProfilMessage getReceiverUser() {
    String b;
    // FirebaseFirestore.instance.collection("utilisateurs").doc(peer).get().then((value){
    //   print(value.data());
    //   b = value.data()['nom'];
    //   return ProfilMessage(value.data()['nom'], 'images/avatar/a3.jpg');
    // });
    return ProfilMessage(peer, 'https://firebasestorage.googleapis.com/v0/b/exolearn-a9a0e.appspot.com/o/users%2FlFtUmTNGA3ey2POxYLLuCQewyo12%2Fprofil%2F1649094197683.jpeg?alt=media&token=0d0e1593-903f-4721-9574-92d5bd01bde0');
  }
}

class ProfilMessage {
  final String nom;
  final String profil;

  ProfilMessage(this.nom, this.profil);
}