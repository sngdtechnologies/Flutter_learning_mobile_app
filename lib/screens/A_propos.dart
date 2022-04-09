import 'package:premiere/constants/ArgonColors.dart';
import 'package:flutter/material.dart';

// import 'package:argon_flutter/constants/Theme.dart';

//widgets
import 'package:premiere/widgets/navbar.dart';
import 'package:premiere/widgets/card-horizontal.dart';
// import 'package:premiere/widgets/card-small.dart';
// import 'package:premiere/widgets/card-square.dart';
import 'package:premiere/widgets/drawer.dart';

final Map<String, Map<String, String>> homeCards = {
  "Ice Cream": {
    "title": "Ice cream is made with carrageenan …",
    "image": "assets/img/img1.jpg"
  },
  "Makeup": {
    "title": "Is makeup one of your daily esse …",
    "image": "assets/img/img1.jpg"
  },
  "Coffee": {
    "title": "Coffee is more than just a drink: It’s …",
    "image": "assets/img/img1.jpg"
  },
  "Fashion": {
    "title": "Fashion is a popular style, especially in …",
    "image": "assets/img/img2.jpg"
  },
  "Argon": {
    "title": "Argon is a great free UI packag …",
    "image": "assets/img/img3.jpg"
  }
};

class AproposScreen extends StatelessWidget {
  // final GlobalKey _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        titre: "A propos",
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      // key: _scaffoldKey,
      drawer: ArgonDrawer(currentPage: "Apropos"),
      body: Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CardHorizontal(
                    cta: "1View article",
                    title: homeCards["Ice Cream"]['title'],
                    chemin: homeCards["Ice Cream"]['image'],
                    tap: () {
                      // Navigator.pushNamed(context, '/pro');
                    }),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CardHorizontal(
                    cta: "1View article",
                    title: homeCards["Ice Cream"]['title'],
                    chemin: homeCards["Ice Cream"]['image'],
                    tap: () {
                      // Navigator.pushNamed(context, '/pro');
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
