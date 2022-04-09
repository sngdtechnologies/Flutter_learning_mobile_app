import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieA.dart/Chimie/Cours.dart';
import 'package:premiere/screens/SerieA.dart/Chimie/Exercices.dart';
import 'package:premiere/screens/SerieA.dart/Chimie/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class ChimieSerieA extends StatefulWidget {
  ChimieSerieA({Key key}) : super(key: key);

  @override
  _ChimieSerieAState createState() => _ChimieSerieAState();
}

class _ChimieSerieAState extends State<ChimieSerieA> {
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
