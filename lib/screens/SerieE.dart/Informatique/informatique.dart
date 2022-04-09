import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieE.dart/Informatique/Cours.dart';
import 'package:premiere/screens/SerieE.dart/Informatique/Exercices.dart';
import 'package:premiere/screens/SerieE.dart/Informatique/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class InformatiqueSerieE extends StatefulWidget {
  InformatiqueSerieE({Key key}) : super(key: key);

  @override
  _InformatiqueSerieEState createState() => _InformatiqueSerieEState();
}

class _InformatiqueSerieEState extends State<InformatiqueSerieE> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'Informatique',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "Informatique"),
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
