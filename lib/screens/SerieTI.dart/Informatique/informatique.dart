import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieTI.dart/Informatique/Cours.dart';
import 'package:premiere/screens/SerieTI.dart/Informatique/Exercices.dart';
import 'package:premiere/screens/SerieTI.dart/Informatique/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class InformatiqueSerieTI extends StatefulWidget {
  InformatiqueSerieTI({Key key}) : super(key: key);

  @override
  _InformatiqueSerieTIState createState() => _InformatiqueSerieTIState();
}

class _InformatiqueSerieTIState extends State<InformatiqueSerieTI> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'Informatique',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "Informatique"),
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
