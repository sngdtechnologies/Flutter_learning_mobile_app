import 'package:flutter/material.dart';
import 'package:premiere/screens/Compte/Contrat&Condition.dart';
import 'package:premiere/screens/Compte/Sign_in.dart';

class Welcome extends StatefulWidget {
  Welcome({Key key, this.accept = false}) : super(key: key);
  final bool accept;

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/welcom.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'MesProff-Première',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenue sur ',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'MesProff-Première',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 158.0,
                  ),
                  Container(
                    height: 50.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 50.0,
                          child: RaisedButton(
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              vertical: 15.0,
                            ),
                            color: Theme.of(context).primaryColor,
                            onPressed: widget.accept
                                ? () => Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SignIn()),
                                      ModalRoute.withName('/serie'),
                                    )
                                : null,
                            child: Text(
                              'accept & continue'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Cliquer sur "ACCEPT & CONTINUE" pour accepter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ContratCondition();
                    })),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Contrats & Conditions',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline,
                          height: 3.0,
                        ),
                        children: [
                          TextSpan(
                            text: '  et  ',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          TextSpan(
                            text: 'Politique Privé',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
