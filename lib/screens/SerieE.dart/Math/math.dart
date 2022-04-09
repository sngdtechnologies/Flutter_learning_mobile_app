import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieE.dart/Math/Cours.dart';
import 'package:premiere/screens/SerieE.dart/Math/Exercices.dart';
import 'package:premiere/screens/SerieE.dart/Math/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class MathSerieE extends StatefulWidget {
  MathSerieE({Key key}) : super(key: key);

  @override
  _MathSerieEState createState() => _MathSerieEState();
}

class _MathSerieEState extends State<MathSerieE> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'Mathématique',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "Mathématique"),
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
