import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieE.dart/Physique/Cours.dart';
import 'package:premiere/screens/SerieE.dart/Physique/Exercices.dart';
import 'package:premiere/screens/SerieE.dart/Physique/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class PhysiqueSerieE extends StatefulWidget {
  PhysiqueSerieE({Key key}) : super(key: key);

  @override
  _PhysiqueSerieEState createState() => _PhysiqueSerieEState();
}

class _PhysiqueSerieEState extends State<PhysiqueSerieE> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'Physique',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "Physique"),
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
