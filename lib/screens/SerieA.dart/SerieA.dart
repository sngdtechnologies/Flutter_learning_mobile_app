import 'package:premiere/constants/ArgonColors.dart';
import 'package:premiere/screens/SerieA.dart/Anglais/anglais.dart';
import 'package:premiere/screens/SerieA.dart/Chimie/chimie.dart';
import 'package:premiere/screens/SerieA.dart/Francais/francais.dart';
import 'package:premiere/screens/SerieA.dart/Informatique/informatique.dart';
import 'package:premiere/screens/SerieA.dart/Math/math.dart';
import 'package:premiere/screens/SerieA.dart/Physique/physique.dart';
import 'package:premiere/screens/SerieA.dart/Svt/svt.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:premiere/widgets/navbar.dart';

class SerieA extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Navbar(
        titre: 'Series A',
        icon: Icons.menu,
        scaffoldKey: scaffoldKey,
      ),
      // key: _scaffoldKey,
      drawer: ArgonDrawer(currentPage: "SeriesA"),
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
                  highlightColor: Colors.red,
                  splashColor: Colors.redAccent.shade400,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AnglaisSerieA();
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
                  highlightColor: Colors.red,
                  splashColor: Colors.redAccent.shade400,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ChimieSerieA();
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
                  highlightColor: Colors.red,
                  splashColor: Colors.redAccent.shade400,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return FrancaisSerieA();
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
                  highlightColor: Colors.red,
                  splashColor: Colors.redAccent.shade400,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return InformatiqueSerieA();
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
                  highlightColor: Colors.red,
                  splashColor: Colors.redAccent.shade400,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MathSerieA();
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
                      return PhysiqueSerieA();
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
                      return SvtSerieA();
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
