import 'dart:async';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:premiere/screens/Compte/InfoCompte.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SignIn extends StatefulWidget {
  SignIn({
    Key key,
  }) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final RegExp phoneRegex = RegExp(r"^[0-9]+$");
  final RegExp codeRegex = RegExp(r"[0-9]{6}");
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController otpController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  UserCredential userCredential;

  var action = false;
  var form = false;
  var erreurPhone = false;
  var erreurCode = false;

  var verificationCode = '';

  String nameCountry = '';
  String _codePays = '';
  String _phone = '';
  String _code = '';

  Color color = Colors.grey;
  Color theme = Colors.blue;

  int _start = 60;

  @override
  void initState() {
    _auth.userChanges().listen((event) => setState(() => {user = event}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return signWithPhoneNumber();
  }

  Widget signWithPhoneNumber() {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: theme,
        title: Text(
          'Vérifier votre n° de téléphone',
          style: TextStyle(fontSize: 17.0),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert_outlined),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: GestureDetector(
                  onTap: () => print('Aide'),
                  child: Text('Aide'),
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _globalKey,
            child: (form == false)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Mes Proff va envoyer un SMS (des frais d\'opérateur peuvent être appliqées) pour vérifier votre numéro de téléphone. Saisissez votre indicatif pays et numéro de téléphone.',
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1.03,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 65.0,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.grey),
                          ),
                        ),
                        child: RaisedButton(
                          color: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                          ),
                          // onPressed: () => showAlert(context),
                          onPressed: () {
                            showCountryPicker(
                              context: context,
                              //Optional. Shows phone code before the country name.
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                setState(() {
                                  nameCountry = country.name;
                                  _codePays = country.phoneCode;
                                });
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 11.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        (nameCountry == '')
                                            ? 'Selectionner votre pays'
                                            : nameCountry.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_drop_down,
                                  size: 40, color: theme),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  height: 44.0,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1.0, color: Colors.grey),
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 9.0, horizontal: 20.0),
                                    child: Text(
                                      (_codePays == '')
                                          ? '+ ...'
                                          : '+ ' + _codePays,
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Container(
                                  height: 70.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0, right: 8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: phoneController,
                                      textInputAction: TextInputAction.done,
                                      autocorrect: true,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                      onChanged: (value) => (value.isNotEmpty &&
                                              phoneRegex.hasMatch(value))
                                          ? {
                                              setState(() {
                                                _phone = value;
                                                erreurPhone = false;
                                              }),
                                              if (_codePays != '' &&
                                                  phoneRegex.hasMatch(_phone))
                                                setState(() {
                                                  color = Colors.blueAccent;
                                                }),
                                              // print(color)
                                            }
                                          : {
                                              setState(() {
                                                erreurPhone = true;
                                                color = Colors.grey;
                                              }),
                                              print(color)
                                            },
                                      decoration: InputDecoration(
                                        hintText: 'Ex: 678569858',
                                        hintStyle: TextStyle(
                                          fontSize: 15.0,
                                        ),
                                        prefixIcon: Icon(Icons.phone_android,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (erreurPhone)
                            Text(
                              'Le numéro doit être en chiffre',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 11.0,
                                height: 2,
                              ),
                            )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.20,
                      ),
                      Container(
                        height: 65.0,
                        child: RaisedButton(
                          color: color,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                          ),
                          // onPressed: () => showAlert(context),
                          onPressed: () => {
                            if (erreurPhone == false &&
                                _codePays != '' &&
                                _phone.isNotEmpty)
                              {
                                setState(() {
                                  color = Colors.grey;
                                  form = true;
                                  action = true;
                                  signUp();
                                }),
                              }
                            else
                              {showErrorChamps(context)}
                          },
                          child: Text(
                            'Suivant'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: OTPTextField(
                              length: 6,
                              width: MediaQuery.of(context).size.width,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldWidth: 30,
                              fieldStyle: FieldStyle.underline,
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 17),
                              onChanged: (value) => (value.isNotEmpty &&
                                      codeRegex.hasMatch(value))
                                  ? {
                                      setState(() {
                                        _code = value;
                                        erreurCode = false;
                                      }),
                                    }
                                  : {
                                      setState(() {
                                        erreurCode = true;
                                        color = Colors.grey;
                                      }),
                                    },
                              onCompleted: (value) => (value.isNotEmpty &&
                                      codeRegex.hasMatch(value))
                                  ? {
                                      if (_codePays != '')
                                        setState(() {
                                          _code = value;
                                          color = Colors.blue;
                                        })
                                    }
                                  : {
                                      setState(() {
                                        erreurCode = true;
                                        color = Colors.grey;
                                      }),
                                    },
                            ),
                          ),
                          if (erreurCode)
                            Text(
                              'code Ivalide ( < 6 chiffres)',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 11.0,
                                height: 2,
                              ),
                            )
                        ],
                      ),
                      if (action == true)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text:
                                          "Veuillez saisir le code de validation envoyé par message au ",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '+' +
                                              _codePays +
                                              ' ' +
                                              phoneController.text.trim(),
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: " Veuillez patienter ",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "(0:$_start)",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ', puis cliquer a nouveau',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Vous n'avez pas reçu de code ? ",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => {
                                    setState(() {
                                      action = true;
                                      signUp();
                                    }),
                                  },
                                  child: Text(
                                    "Renvoyer\n",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 65.0,
                            child: RaisedButton(
                              color: color,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                vertical: 15.0,
                              ),
                              // onPressed: () => showAlert(context),
                              onPressed: () {
                                if (erreurCode == false && _code.isNotEmpty) {
                                  displaySnackBar('Veuillez Patienter...');
                                  enregistrerCompte();
                                } else {
                                  showErrorChamps(context);
                                }
                              },
                              child: Text(
                                'Suivant'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void showAlertErreurConnection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(
          Icons.assignment_turned_in_rounded,
          size: 40,
          color: Colors.grey,
        ),
        content: Container(
          height: 70.0,
          child: Center(
            child: Column(
              children: [
                Text(
                  'Erreur !!!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'N\'ous n\'arrivons pas à établir la connection avec la Base de données.\nVeuillez réesaillez ultérieurement',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      ),
    );
  }

  void enregistrerCompte() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          await _auth
              .signInWithCredential(PhoneAuthProvider.credential(
                  verificationId: verificationCode, smsCode: _code))
              .then((user) async {
            var result = await _firestore
                .collection("utilisateurs")
                .where("telephone",
                    isEqualTo: '+' + _codePays + phoneController.text.trim())
                .get();
            var pass;
            if (result.size == 0)
              pass = '';
            else
              pass = result.docs[0].data()["password"];

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => InfoCompte(
                          password: pass,
                        )),
                ModalRoute.withName('/infoCompte'));
          }).catchError((error) => {showAlertErreurCompte(context)});
        } catch (e) {
          displaySnackBar('Une erreur c\'est produite veuillez réesseiller');
        }
      }
    } on SocketException catch (_) {
      afficheInfo('Veuillez-vous connecter . . .');
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void showAlertErreurCompte(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(
          Icons.assignment_turned_in_rounded,
          size: 40,
          color: Colors.grey,
        ),
        content: Container(
          height: 113.0,
          child: Center(
            child: Column(
              children: [
                Text(
                  'Erreur !!!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'N\'ous n\'arrivons pas à créer votre compte.\nVeuillez réesaillez',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      ),
    );
  }

  void showErrorChamps(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(
          Icons.assignment_turned_in_rounded,
          size: 40,
          color: Colors.grey,
        ),
        content: Container(
          height: 75.0,
          child: Center(
            child: Column(
              children: [
                Text(
                  'Attention !!!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Veuillez remplir les champs pour continuer',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      ),
    );
  }

  Future signUp() async {
    // print('code');
    _start = 60;
    const oneDecimal = const Duration(seconds: 2);
    Timer _timer = new Timer.periodic(
        oneDecimal,
        (Timer timer) => setState(() {
              if (_start < 1) {
                action = false;
                timer.cancel();
              } else {
                _start = _start - 1;
              }
            }));
    // _timer;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          var _phoneNumber = '+' + _codePays + phoneController.text.trim();
          var verifyPhonenumber = _auth.verifyPhoneNumber(
              phoneNumber: _phoneNumber,
              verificationCompleted: (phoneAuthCredential) {
                _auth
                    .signInWithCredential(phoneAuthCredential)
                    .then((user) async => {});
              },
              verificationFailed: (FirebaseAuthException error) {
                debugPrint('Erreur de chargement: ' + error.message);
                // setState(() {
                //   isLoading = false;
                // });
              },
              codeSent: (verificationId, [foreResendingToken]) {
                setState(() {
                  // isLoading = false;
                  verificationCode = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (String verificationId) {
                setState(() {
                  // isLoading = false;
                  verificationCode = verificationId;
                });
              },
              timeout: Duration(seconds: 10));
          await verifyPhonenumber;
        } catch (e) {
          displaySnackBar(
              'Une erreur c\'est produite veuillez réesseiller ultérieurement ');
        }
      }
    } on SocketException catch (_) {
      afficheInfo('Veuillez-vous connecter . . .');
    }
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.blue,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  afficheInfo(text) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.signal_wifi_off_rounded, size: 20, color: Colors.white),
          Text(text, style: TextStyle(color: Colors.white)),
        ],
      ),
      backgroundColor: Colors.blue,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
