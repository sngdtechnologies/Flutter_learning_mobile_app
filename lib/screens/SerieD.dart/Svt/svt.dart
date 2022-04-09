import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieD.dart/Svt/Cours.dart';
import 'package:premiere/screens/SerieD.dart/Svt/Exercices.dart';
import 'package:premiere/screens/SerieD.dart/Svt/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class SvtSerieD extends StatefulWidget {
  SvtSerieD({Key key}) : super(key: key);

  @override
  _SvtSerieDState createState() => _SvtSerieDState();
}

class _SvtSerieDState extends State<SvtSerieD> {
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
