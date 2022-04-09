import 'package:premiere/constants/ArgonColors.dart';
import 'package:flutter/material.dart';
import 'package:premiere/screens/BlinkingToast.dart';
import 'package:premiere/screens/SerieA.dart/SerieA.dart';
import 'package:premiere/screens/SerieC.dart/SerieC.dart';
import 'package:premiere/screens/SerieD.dart/SerieD.dart';
import 'package:premiere/screens/SerieE.dart/SerieE.dart';
import 'package:premiere/screens/SerieTI.dart/SerieTI.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar.dart';

class Serie extends StatefulWidget {
  final String tel;

  Serie({Key key, this.tel = ''}) : super(key: key);

  @override
  _SerieState createState() => _SerieState();
}

class _SerieState extends State<Serie> {
  final GlobalKey scaffoldKey = new GlobalKey();
  BlinkingToast toast = new BlinkingToast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: Navbar(
        titre: 'Series',
        icon: Icons.menu,
        scaffoldKey: scaffoldKey,
      ),
      // key: _scaffoldKey,
      drawer: ArgonDrawer(currentPage: "Series"),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.greenAccent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      onPressed: () {
                        // toast.show(
                        //   context: context,
                        //   externalBuilder: (BuildContext context) {
                        //     return new Icon(Icons.warning,
                        //         color: Colors.purple);
                        //   },
                        //   duration: new Duration(seconds: 10),
                        //   position: new Offset(100.0, 100.0),
                        // );
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SerieA();
                        }));
                      },
                      child: Text(
                        'Serie A',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    RaisedButton(
                      color: ArgonColors.info,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SerieD();
                        }));
                      },
                      child: Text(
                        'Serie D',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.blue,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SerieC();
                        }));
                      },
                      child: Text(
                        'Serie C',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    RaisedButton(
                      color: Colors.amberAccent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SerieE();
                        }));
                      },
                      child: Text(
                        'Serie E',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.cyan,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SerieTI();
                        }));
                      },
                      child: Text(
                        'Serie TI',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
