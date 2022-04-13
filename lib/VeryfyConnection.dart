import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:premiere/screens/Accueil.dart';
import 'package:premiere/screens/Compte/InfoCompte.dart';
import 'package:premiere/screens/Compte/Sign_in.dart';
import 'package:premiere/screens/Serie.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class VeryfyConnection extends StatefulWidget {
  @override
  _VeryfyConnectionState createState() => _VeryfyConnectionState();
}

class _VeryfyConnectionState extends State<VeryfyConnection> {
  var doc = true;

  _onDocumentExists() async{
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    var result = await _firestore.collection("utilisateurs").doc(firebaseUser.uid).get();
    setState(() {
      doc = result.exists;
    });
    // return doc ? Serie() : InfoCompte();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return AccueilScreen();
        } else {
          _onDocumentExists();
          
          // print(doc);
          // return Container();
          return doc ? Serie() : InfoCompte();
        }
      },
    );
  }
}