import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieD.dart/Francais/Cours.dart';
import 'package:premiere/screens/SerieD.dart/Francais/Exercices.dart';
import 'package:premiere/screens/SerieD.dart/Francais/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class FrancaisSerieD extends StatefulWidget {
  FrancaisSerieD({Key key}) : super(key: key);

  @override
  _FrancaisSerieDState createState() => _FrancaisSerieDState();
}

class _FrancaisSerieDState extends State<FrancaisSerieD> {
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
