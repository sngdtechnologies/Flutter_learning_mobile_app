import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieTI.dart/Chimie/Cours.dart';
import 'package:premiere/screens/SerieTI.dart/Chimie/Exercices.dart';
import 'package:premiere/screens/SerieTI.dart/Chimie/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class ChimieSerieTI extends StatefulWidget {
  ChimieSerieTI({Key key}) : super(key: key);

  @override
  _ChimieSerieTIState createState() => _ChimieSerieTIState();
}

class _ChimieSerieTIState extends State<ChimieSerieTI> {
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
