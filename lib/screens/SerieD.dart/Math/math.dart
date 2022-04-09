import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieD.dart/Math/Cours.dart';
import 'package:premiere/screens/SerieD.dart/Math/Exercices.dart';
import 'package:premiere/screens/SerieD.dart/Math/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class MathSerieD extends StatefulWidget {
  MathSerieD({Key key}) : super(key: key);

  @override
  _MathSerieDState createState() => _MathSerieDState();
}

class _MathSerieDState extends State<MathSerieD> {
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
