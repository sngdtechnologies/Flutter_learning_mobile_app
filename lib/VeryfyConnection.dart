import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:premiere/screens/Accueil.dart';
import 'package:premiere/screens/Serie.dart';

class VeryfyConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return AccueilScreen();
        } else {
          return Serie();
        }
      },
    );
  }
}