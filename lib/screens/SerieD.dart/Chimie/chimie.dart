import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieD.dart/Chimie/Cours.dart';
import 'package:premiere/screens/SerieD.dart/Chimie/Exercices.dart';
import 'package:premiere/screens/SerieD.dart/Chimie/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class ChimieSerieD extends StatefulWidget {
  ChimieSerieD({Key key}) : super(key: key);

  @override
  _ChimieSerieDState createState() => _ChimieSerieDState();
}

class _ChimieSerieDState extends State<ChimieSerieD> {
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
