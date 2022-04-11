import 'package:premiere/constants/ArgonColors.dart';
import 'package:flutter/material.dart';
import 'package:premiere/screens/A_propos.dart';
import 'package:premiere/screens/Help.dart';
import 'package:premiere/screens/Profil/Profil.dart';
import 'package:premiere/screens/Serie.dart';
import 'package:premiere/screens/Chat/HomePage.dart';

import 'package:premiere/widgets/drawer-tile.dart';

class ArgonDrawer extends StatelessWidget {
  final String currentPage;

  ArgonDrawer({this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: ArgonColors.white,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.94,
            child: SafeArea(
              // bottom: false,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35.0,
                        backgroundImage: AssetImage('assets/img/splash.png'),
                      ),
                      Flexible(
                        child: Text(
                          '',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.0),
                    bottomLeft: Radius.circular(6.0)),
                image: DecorationImage(
                  image: AssetImage('assets/img/background.jpg'),
                  fit: BoxFit.fitWidth,
                ))),
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.only(top: 24, left: 8, right: 8),
            children: [
              // Divider(height: 4, thickness: 0, color: ArgonColors.muted),

              DrawerTile(
                  icon: Icons.class__rounded,
                  onTap: () {
                    if (currentPage != "Series") {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Serie();
                      }));
                    }
                  },
                  iconColor: Colors.blue,
                  title: "Series",
                  isSelected: currentPage == "Series" ? true : false),
              DrawerTile(
                  icon: Icons.person,
                  onTap: () {
                    if (currentPage != "Profil") {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Profil();
                      }));
                    }
                  },
                  iconColor: Colors.deepPurple,
                  title: "Profil",
                  isSelected: currentPage == "Profil" ? true : false),
              DrawerTile(
                  icon: Icons.help_outline_outlined,
                  onTap: () {
                    if (currentPage != "Help") {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Help();
                      }));
                    }
                    // print('Coucou');
                  },
                  iconColor: ArgonColors.info,
                  title: "Help",
                  isSelected: currentPage == "Help" ? true : false),
              DrawerTile(
                  icon: Icons.notification_important,
                  onTap: () {
                    if (currentPage != "Apropos") {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return AproposScreen();
                      }));
                    }
                    // print('Coucou');
                  },
                  iconColor: Colors.brown,
                  title: "A propos de nous",
                  isSelected: currentPage == "Apropos" ? true : false),
              DrawerTile(
                  icon: Icons.person,
                  onTap: () {
                    if (currentPage != "Chat") {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return HomePage();
                      }));
                      // return PageRouteBuilder(
                      //   pageBuilder: (context, animation, secondaryAnimation) =>
                      //       HomePage(),
                      //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      //     animation = CurvedAnimation(curve: Curves.ease, parent: animation);
                      //     return FadeTransition(
                      //       opacity: animation,
                      //       child: child,
                      //     );
                      //   }
                      // );
                      // Navigator.pushNamed(context, '/chat');
                    }
                  },
                  iconColor: Colors.deepPurple,
                  title: "Chat",
                  isSelected: currentPage == "Chat" ? true : false),
            ],
          ),
        ),
      ]),
    ));
  }
}
