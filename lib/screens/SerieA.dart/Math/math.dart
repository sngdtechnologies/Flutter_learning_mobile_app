import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieA.dart/Math/Cours.dart';
import 'package:premiere/screens/SerieA.dart/Math/Exercices.dart';
import 'package:premiere/screens/SerieA.dart/Math/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class MathSerieA extends StatefulWidget {
  MathSerieA({Key key}) : super(key: key);

  @override
  _MathSerieAState createState() => _MathSerieAState();
}

class _MathSerieAState extends State<MathSerieA> {
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
