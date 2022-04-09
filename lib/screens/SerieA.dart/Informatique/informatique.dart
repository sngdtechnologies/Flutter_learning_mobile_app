import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieA.dart/Informatique/Cours.dart';
import 'package:premiere/screens/SerieA.dart/Informatique/Exercices.dart';
import 'package:premiere/screens/SerieA.dart/Informatique/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class InformatiqueSerieA extends StatefulWidget {
  InformatiqueSerieA({Key key}) : super(key: key);

  @override
  _InformatiqueSerieAState createState() => _InformatiqueSerieAState();
}

class _InformatiqueSerieAState extends State<InformatiqueSerieA> {
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
