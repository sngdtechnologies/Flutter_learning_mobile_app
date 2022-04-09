import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieC.dart/Chimie/Cours.dart';
import 'package:premiere/screens/SerieC.dart/Chimie/Exercices.dart';
import 'package:premiere/screens/SerieC.dart/Chimie/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class ChimieSerieC extends StatefulWidget {
  ChimieSerieC({Key key}) : super(key: key);

  @override
  _ChimieSerieCState createState() => _ChimieSerieCState();
}

class _ChimieSerieCState extends State<ChimieSerieC> {
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
