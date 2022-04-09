import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieC.dart/Anglais/Cours.dart';
import 'package:premiere/screens/SerieC.dart/Anglais/Exercices.dart';
import 'package:premiere/screens/SerieC.dart/Anglais/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class AnglaisSerieC extends StatefulWidget {
  AnglaisSerieC({Key key}) : super(key: key);

  @override
  _AnglaisSerieCState createState() => _AnglaisSerieCState();
}

class _AnglaisSerieCState extends State<AnglaisSerieC> {
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
