import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieE.dart/Svt/Cours.dart';
import 'package:premiere/screens/SerieE.dart/Svt/Exercices.dart';
import 'package:premiere/screens/SerieE.dart/Svt/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class SvtSerieE extends StatefulWidget {
  SvtSerieE({Key key}) : super(key: key);

  @override
  _SvtSerieEState createState() => _SvtSerieEState();
}

class _SvtSerieEState extends State<SvtSerieE> {
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
