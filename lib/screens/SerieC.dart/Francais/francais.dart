import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieC.dart/Francais/Cours.dart';
import 'package:premiere/screens/SerieC.dart/Francais/Exercices.dart';
import 'package:premiere/screens/SerieC.dart/Francais/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class FrancaisSerieC extends StatefulWidget {
  FrancaisSerieC({Key key}) : super(key: key);

  @override
  _FrancaisSerieCState createState() => _FrancaisSerieCState();
}

class _FrancaisSerieCState extends State<FrancaisSerieC> {
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
