import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieD.dart/Informatique/Cours.dart';
import 'package:premiere/screens/SerieD.dart/Informatique/Exercices.dart';
import 'package:premiere/screens/SerieD.dart/Informatique/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class InformatiqueSerieD extends StatefulWidget {
  InformatiqueSerieD({Key key}) : super(key: key);

  @override
  _InformatiqueSerieDState createState() => _InformatiqueSerieDState();
}

class _InformatiqueSerieDState extends State<InformatiqueSerieD> {
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
