import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieA.dart/Francais/Cours.dart';
import 'package:premiere/screens/SerieA.dart/Francais/Exercices.dart';
import 'package:premiere/screens/SerieA.dart/Francais/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class FrancaisSerieA extends StatefulWidget {
  FrancaisSerieA({Key key}) : super(key: key);

  @override
  _FrancaisSerieAState createState() => _FrancaisSerieAState();
}

class _FrancaisSerieAState extends State<FrancaisSerieA> {
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
