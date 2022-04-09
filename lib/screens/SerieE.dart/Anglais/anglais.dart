import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieE.dart/Anglais/Cours.dart';
import 'package:premiere/screens/SerieE.dart/Anglais/Exercices.dart';
import 'package:premiere/screens/SerieE.dart/Anglais/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class AnglaisSerieE extends StatefulWidget {
  AnglaisSerieE({Key key}) : super(key: key);

  @override
  _AnglaisSerieEState createState() => _AnglaisSerieEState();
}

class _AnglaisSerieEState extends State<AnglaisSerieE> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'Anglais',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "Anglais"),
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
