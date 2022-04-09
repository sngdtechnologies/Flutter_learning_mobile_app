import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieTI.dart/Math/Cours.dart';
import 'package:premiere/screens/SerieTI.dart/Math/Exercices.dart';
import 'package:premiere/screens/SerieTI.dart/Math/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class MathSerieTI extends StatefulWidget {
  MathSerieTI({Key key}) : super(key: key);

  @override
  _MathSerieTIState createState() => _MathSerieTIState();
}

class _MathSerieTIState extends State<MathSerieTI> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'Mathématique',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "Mathématique"),
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
