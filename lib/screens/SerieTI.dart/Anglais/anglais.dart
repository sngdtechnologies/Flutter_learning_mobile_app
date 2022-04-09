import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieTI.dart/Anglais/Cours.dart';
import 'package:premiere/screens/SerieTI.dart/Anglais/Exercices.dart';
import 'package:premiere/screens/SerieTI.dart/Anglais/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class AnglaisSerieTI extends StatefulWidget {
  AnglaisSerieTI({Key key}) : super(key: key);

  @override
  _AnglaisSerieTIState createState() => _AnglaisSerieTIState();
}

class _AnglaisSerieTIState extends State<AnglaisSerieTI> {
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
