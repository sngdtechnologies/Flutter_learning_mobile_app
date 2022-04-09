import 'package:flutter/material.dart';
import 'package:premiere/screens/SerieA.dart/Anglais/Cours.dart';
import 'package:premiere/screens/SerieA.dart/Anglais/Exercices.dart';
import 'package:premiere/screens/SerieA.dart/Anglais/Tp.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar-title.dart';

class AnglaisSerieA extends StatefulWidget {
  AnglaisSerieA({Key key}) : super(key: key);

  @override
  _AnglaisSerieAState createState() => _AnglaisSerieAState();
}

class _AnglaisSerieAState extends State<AnglaisSerieA> {
  bool _firstSearch = true;
  String _query = "";
  var _searchview = new TextEditingController();
  _AnglaisSerieAState() {
    //Register a closure to be called when the object changes.
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: Navbartitle(
          titre: 'Anglais',
          icon: Icons.arrow_back,
          searchview: _searchview,
        ),
        drawer: ArgonDrawer(currentPage: "Anglais"),
        body: TabBarView(
          children: [
            new CoursSScreen(
              query: _query,
              firstSearch: _firstSearch,
            ),
            new ExercicesSScreen(
              query: _query,
              firstSearch: _firstSearch,
            ),
            new TpSScreen(
              query: _query,
              firstSearch: _firstSearch,
            ),
          ],
        ),
      ),
    );
  }
}
