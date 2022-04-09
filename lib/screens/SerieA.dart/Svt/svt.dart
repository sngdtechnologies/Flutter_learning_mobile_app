import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieA.dart/Svt/Cours.dart';
import 'package:premiere/screens/SerieA.dart/Svt/Exercices.dart';
import 'package:premiere/screens/SerieA.dart/Svt/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class SvtSerieA extends StatefulWidget {
  SvtSerieA({Key key}) : super(key: key);

  @override
  _SvtSerieAState createState() => _SvtSerieAState();
}

class _SvtSerieAState extends State<SvtSerieA> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'SVT',
          icon: Icons.arrow_back,
        ),
        drawer: ArgonDrawer(currentPage: "SVT"),
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
