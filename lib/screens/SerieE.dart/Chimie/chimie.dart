import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieE.dart/Chimie/Cours.dart';
import 'package:premiere/screens/SerieE.dart/Chimie/Exercices.dart';
import 'package:premiere/screens/SerieE.dart/Chimie/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class ChimieSerieE extends StatefulWidget {
  ChimieSerieE({Key key}) : super(key: key);

  @override
  _ChimieSerieEState createState() => _ChimieSerieEState();
}

class _ChimieSerieEState extends State<ChimieSerieE> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'Chimie',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "Chimie"),
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
