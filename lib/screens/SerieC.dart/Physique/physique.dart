import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieC.dart/Physique/Cours.dart';
import 'package:premiere/screens/SerieC.dart/Physique/Exercices.dart';
import 'package:premiere/screens/SerieC.dart/Physique/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class PhysiqueSerieC extends StatefulWidget {
  PhysiqueSerieC({Key key}) : super(key: key);

  @override
  _PhysiqueSerieCState createState() => _PhysiqueSerieCState();
}

class _PhysiqueSerieCState extends State<PhysiqueSerieC> {
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
