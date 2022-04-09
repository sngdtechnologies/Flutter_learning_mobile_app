import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieTI.dart/Francais/Cours.dart';
import 'package:premiere/screens/SerieTI.dart/Francais/Exercices.dart';
import 'package:premiere/screens/SerieTI.dart/Francais/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class FrancaisSerieE extends StatefulWidget {
  FrancaisSerieE({Key key}) : super(key: key);

  @override
  _FrancaisSerieEState createState() => _FrancaisSerieEState();
}

class _FrancaisSerieEState extends State<FrancaisSerieE> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'Francais',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "Francais"),
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
