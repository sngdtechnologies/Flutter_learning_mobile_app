import 'package:premiere/constants/ArgonColors.dart';
import 'package:premiere/screens/SerieE.dart/Anglais/anglais.dart';
import 'package:premiere/screens/SerieE.dart/Chimie/chimie.dart';
import 'package:premiere/screens/SerieE.dart/Francais/francais.dart';
import 'package:premiere/screens/SerieE.dart/Informatique/informatique.dart';
import 'package:premiere/screens/SerieE.dart/Math/math.dart';
import 'package:premiere/screens/SerieE.dart/Physique/physique.dart';
import 'package:premiere/screens/SerieE.dart/Svt/svt.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:premiere/widgets/navbar.dart';

class SerieE extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Navbar(
        titre: 'Series E',
        icon: Icons.menu,
        scaffoldKey: scaffoldKey,
      ),
      // key: _scaffoldKey,
      drawer: ArgonDrawer(currentPage: "SeriesE"),
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
                      return AnglaisSerieE();
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
                      return ChimieSerieE();
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
                      return FrancaisSerieE();
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
                      return InformatiqueSerieE();
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
                      return MathSerieE();
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
                      return PhysiqueSerieE();
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
                      return SvtSerieE();
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
