import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:premiere/constants/ArgonColors.dart';
import 'package:flutter/material.dart';
import 'package:premiere/screens/Accueil.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  final String titre;
  final IconData icon;
  final Color theme;
  final scaffoldKey;

  Navbar({
    this.titre = "Accueil",
    this.icon = Icons.arrow_back,
    this.theme = Colors.blue,
    this.scaffoldKey,
  });

  final double _prefferedHeight = 56.0;

  @override
  _NavbarState createState() => _NavbarState();

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: widget.theme,
          leading: IconButton(
              icon: Icon(widget.icon, color: ArgonColors.white, size: 24.0),
              onPressed: () => (widget.icon == Icons.menu)
                  ? Scaffold.of(context).openDrawer()
                  : Navigator.pop(context)),
          title: Text(widget.titre),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.more_vert_outlined),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/a_propos');
                    },
                    child: Text('A propos de nous'),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: GestureDetector(
                    onTap: () {
                      showDeconnexion(context);
                    },
                    child: Text('Déconnexion'),
                  ),
                ),
              ],
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(60),
              bottomLeft: Radius.circular(60),
            ),
          ),
        ),
      ],
    );
  }

  void showDeconnexion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: null,
        content: Container(
          height: 142.0,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Déconnexion',
                    style: TextStyle(
                        letterSpacing: 1, fontSize: 15, color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Text(
                    'Voullez-vous vraiment vous déconnecter ?',
                    style: TextStyle(
                        letterSpacing: 1, fontSize: 15, color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Non',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {
                            final User user = _auth.currentUser;
                            if (user == null) {
                              Scaffold.of(context).showSnackBar(const SnackBar(
                                content: Text('Aucun compte créer.'),
                              ));
                              return;
                            }
                            await _signOut().then((value) => {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return AccueilScreen();
                                  }))
                                  // Navigator.pop(
                                  //     context)
                                });
                          }
                        } on SocketException catch (_) {
                          affiche('Veuillez-vous connecter . . .',
                              Icons.signal_wifi_off_rounded);
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Oui',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      ),
    );
  }

  // Example code for sign out.
  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      // Navigator.pop(context);
    } catch (e) {
      affiche('Une erreur c\'est produite veuillez réesseller ultérieurement ',
          null);
    }
  }

  affiche(text, icon) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          Text(text, style: TextStyle(color: Colors.white)),
        ],
      ),
      backgroundColor: widget.theme,
    );
    widget.scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
