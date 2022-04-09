import 'package:premiere/constants/ArgonColors.dart';
import 'package:premiere/screens/SerieTI.dart/Anglais/anglais.dart';
import 'package:premiere/screens/SerieTI.dart/Chimie/chimie.dart';
import 'package:premiere/screens/SerieTI.dart/Francais/francais.dart';
import 'package:premiere/screens/SerieTI.dart/Informatique/informatique.dart';
import 'package:premiere/screens/SerieTI.dart/Math/math.dart';
import 'package:premiere/screens/SerieTI.dart/Physique/physique.dart';
import 'package:premiere/screens/SerieTI.dart/Svt/svt.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:premiere/widgets/navbar.dart';

class SerieTI extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Navbar(
        titre: 'Series TI',
        icon: Icons.menu,
        scaffoldKey: scaffoldKey,
      ),
      // key: _scaffoldKey,
      drawer: ArgonDrawer(currentPage: "SeriesTI"),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.greenAccent,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AnglaisSerieTI();
                    }));
                  },
                  child: Text(
                    'Anglais',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  color: ArgonColors.info,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ChimieSerieTI();
                    }));
                  },
                  child: Text(
                    'Chimie',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  color: Colors.blue,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return FrancaisSerieTI();
                    }));
                  },
                  child: Text(
                    'Français',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  color: Colors.amberAccent,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return InformatiqueSerieTI();
                    }));
                  },
                  child: Text(
                    'Informatique',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  color: Colors.cyan,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MathSerieTI();
                    }));
                  },
                  child: Text(
                    'Mathématique',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  color: Colors.greenAccent,
                  highlightColor: Colors.red,
                  splashColor: Colors.redAccent.shade400,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return PhysiqueSerieTI();
                    }));
                  },
                  child: Text(
                    'Physique',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                  color: Colors.indigo,
                  highlightColor: Colors.red,
                  splashColor: Colors.redAccent.shade400,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return SvtSerieTI();
                    }));
                  },
                  child: Text(
                    'Svt',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
