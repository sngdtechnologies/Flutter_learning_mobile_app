import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieD.dart/Anglais/Cours.dart';
import 'package:premiere/screens/SerieD.dart/Anglais/Exercices.dart';
import 'package:premiere/screens/SerieD.dart/Anglais/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class AnglaisSerieD extends StatefulWidget {
  AnglaisSerieD({Key key}) : super(key: key);

  @override
  _AnglaisSerieDState createState() => _AnglaisSerieDState();
}

class _AnglaisSerieDState extends State<AnglaisSerieD> {
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
