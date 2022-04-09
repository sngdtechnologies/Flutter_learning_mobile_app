import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieA.dart/Physique/Cours.dart';
import 'package:premiere/screens/SerieA.dart/Physique/Exercices.dart';
import 'package:premiere/screens/SerieA.dart/Physique/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class PhysiqueSerieA extends StatefulWidget {
  PhysiqueSerieA({Key key}) : super(key: key);

  @override
  _PhysiqueSerieAState createState() => _PhysiqueSerieAState();
}

class _PhysiqueSerieAState extends State<PhysiqueSerieA> {
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
