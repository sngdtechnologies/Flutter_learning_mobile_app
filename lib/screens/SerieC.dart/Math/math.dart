import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieC.dart/Math/Cours.dart';
import 'package:premiere/screens/SerieC.dart/Math/Exercices.dart';
import 'package:premiere/screens/SerieC.dart/Math/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class MathSerieC extends StatefulWidget {
  MathSerieC({Key key}) : super(key: key);

  @override
  _MathSerieCState createState() => _MathSerieCState();
}

class _MathSerieCState extends State<MathSerieC> {
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
