import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieD.dart/Physique/Cours.dart';
import 'package:premiere/screens/SerieD.dart/Physique/Exercices.dart';
import 'package:premiere/screens/SerieD.dart/Physique/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class PhysiqueSerieD extends StatefulWidget {
  PhysiqueSerieD({Key key}) : super(key: key);

  @override
  _PhysiqueSerieDState createState() => _PhysiqueSerieDState();
}

class _PhysiqueSerieDState extends State<PhysiqueSerieD> {
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
