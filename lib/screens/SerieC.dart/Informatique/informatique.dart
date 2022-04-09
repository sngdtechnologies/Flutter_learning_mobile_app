import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieC.dart/Informatique/Cours.dart';
import 'package:premiere/screens/SerieC.dart/Informatique/Exercices.dart';
import 'package:premiere/screens/SerieC.dart/Informatique/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class InformatiqueSerieC extends StatefulWidget {
  InformatiqueSerieC({Key key}) : super(key: key);

  @override
  _InformatiqueSerieCState createState() => _InformatiqueSerieCState();
}

class _InformatiqueSerieCState extends State<InformatiqueSerieC> {
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
