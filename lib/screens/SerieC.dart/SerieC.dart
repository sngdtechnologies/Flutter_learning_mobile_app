import 'package:premiere/constants/ArgonColors.dart';
import 'package:premiere/screens/SerieC.dart/Anglais/anglais.dart';
import 'package:premiere/screens/SerieC.dart/Chimie/chimie.dart';
import 'package:premiere/screens/SerieC.dart/Francais/francais.dart';
import 'package:premiere/screens/SerieC.dart/Informatique/informatique.dart';
import 'package:premiere/screens/SerieC.dart/Math/math.dart';
import 'package:premiere/screens/SerieC.dart/Physique/physique.dart';
import 'package:premiere/screens/SerieC.dart/Svt/svt.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:premiere/widgets/navbar.dart';

class SerieC extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Navbar(
        titre: 'Series C',
        icon: Icons.menu,
        scaffoldKey: scaffoldKey,
      ),
      // key: _scaffoldKey,
      drawer: ArgonDrawer(currentPage: "SeriesC"),
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
                      return AnglaisSerieC();
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
                      return ChimieSerieC();
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
                      return FrancaisSerieC();
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
                      return InformatiqueSerieC();
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
                      return MathSerieC();
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
                      return PhysiqueSerieC();
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
                      return SvtSerieC();
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
