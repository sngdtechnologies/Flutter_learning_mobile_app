import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:premiere/screens/Compte/Welcome.dart';

class AccueilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Bienvenue dans MesProff Première\n',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'L\'application qui vous offres des Cours, Exercice et Tp gratuit.\n',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Des contenues provenant de divers Etablissement\n',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return Welcome();
          }));
          // print('Coucou2');
        },
        tooltip: 'Cliquer',
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
