import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieTI.dart/Physique/Cours.dart';
import 'package:premiere/screens/SerieTI.dart/Physique/Exercices.dart';
import 'package:premiere/screens/SerieTI.dart/Physique/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class PhysiqueSerieTI extends StatefulWidget {
  PhysiqueSerieTI({Key key}) : super(key: key);

  @override
  _PhysiqueSerieTIState createState() => _PhysiqueSerieTIState();
}

class _PhysiqueSerieTIState extends State<PhysiqueSerieTI> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'Physique',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "Physique"),
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
