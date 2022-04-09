import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:premiere/models/user.dart';
import 'package:premiere/services/message_database.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection("utilisateurs");
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
   final MessageDatabaseService messageService = MessageDatabaseService();

  Future<void> saveUser(String nom, int telephone) async {
    return await userCollection.doc(uid).set({'nom': nom, 'telephone': telephone});
  }

  Future<void> saveToken(String token) async {
    return await userCollection.doc(uid).update({'token': token});
  }

  AppUserData _userFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception("user not found");
    return AppUserData(
      uid: snapshot.id,
      nom: data['nom'],
      timestamps: data['timestamps'],
    );
  }

  // Stream<List<AppUserData>> getStreamOfMyModel() {
  //   // Query queryUser = userCollection.orderBy('carTimestamp', descending: false);
  //   return userCollection.snapshots().map((snapshot) => 
  //     snapshot.docs.map((doc) {
  //       AppUserData(
  //         uid: doc.id,
  //         nom: doc.get('nom'),
  //         profil: doc.get('profil'),
  //         timestamps: doc.get('timestamps'),
  //       );
  //     }).toList() 
  //   );
  // }

  // Stream<List<AppUserData>> getStreamOfMyModel() {
  //   // Query queryUser = userCollection.orderBy('carTimestamp', descending: false);
  //   return userCollection.snapshots().map((snapshot) => 
  //     snapshot.docs.map((doc) {
  //       print(doc.get('nom'));
  //       AppUserData(
  //         uid: doc.id,
  //         nom: doc.get('nom'),
  //         profil: doc.get('profil'),
  //         recentMsg: messageService.getLastMessage(doc.id)['lastMessage'],
  //         unRead: messageService.getUnRead(doc.id),
  //         timestamps: messageService.getLastMessage(doc.id)['timestamps'],
  //       );
  //     }).toList() 
  //   );
  // }

  Stream<AppUserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  Stream<List<Map<String, dynamic>>> getStreamOfMyModel() { //                        <--- Stream
    // return Stream<String>.value('Coucou');
    List<Map<String, dynamic>> listUser = [];
    Map<String, dynamic> _appUserData;
    
    _firebaseFirestore.collection("utilisateurs").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        _appUserData = {
          'uid': result.id,
          'nom': result.data()["nom"],
          'profil': result.data()["profil"],
          'recentMsg': messageService.getLastMessage(result.data()["uid"])['lastMessage'],
          'unRead': messageService.getUnRead(result.data()["uid"]),
          'timestamp': messageService.getLastMessage(result.data()["uid"])['timestamp'],
        };
        listUser.add(_appUserData);
      });
    });

    return Stream.value(listUser);
  }

  List<Map<String, dynamic>> connection() {
    List<Map<String, dynamic>> listUser = [];
    Map<String, dynamic> _appUserData;

    _firebaseFirestore.collection("utilisateurs").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        _appUserData = result.data();
        listUser.add(_appUserData);
      });
    });
    return listUser;
  }
  Stream<List<AppUserData>> get usersList => Stream.value(connection().map((e) => AppUserData(uid: e["uid"], nom: e["nom"], profil: e["profil"], timestamps: e["timestamps"])).toList());

  List<AppUserData> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _userFromSnapshot(doc);
    }).toList();
  }

  // Stream<List<AppUserData>> get users {
  //   return userCollection.snapshots().map(_userListFromSnapshot);
  // }
}
