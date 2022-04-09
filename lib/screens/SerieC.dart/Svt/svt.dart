import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieC.dart/Svt/Cours.dart';
import 'package:premiere/screens/SerieC.dart/Svt/Exercices.dart';
import 'package:premiere/screens/SerieC.dart/Svt/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class SvtSerieC extends StatefulWidget {
  SvtSerieC({Key key}) : super(key: key);

  @override
  _SvtSerieCState createState() => _SvtSerieCState();
}

class _SvtSerieCState extends State<SvtSerieC> {
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
