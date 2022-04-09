import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieTI.dart/Svt/Cours.dart';
import 'package:premiere/screens/SerieTI.dart/Svt/Exercices.dart';
import 'package:premiere/screens/SerieTI.dart/Svt/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class SvtSerieTI extends StatefulWidget {
  SvtSerieTI({Key key}) : super(key: key);

  @override
  _SvtSerieTIState createState() => _SvtSerieTIState();
}

class _SvtSerieTIState extends State<SvtSerieTI> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'SVT',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "SVT"),
        body: TabBarView(
          children: [
            new CoursSScreen(),
            new ExercicesSScreen(),
            new TpSScreen(),
          ],
        ),
      ),
    );
  }
}
