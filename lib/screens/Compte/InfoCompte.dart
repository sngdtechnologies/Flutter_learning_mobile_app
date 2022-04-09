import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:premiere/screens/Loading.dart';
import 'package:premiere/screens/Serie.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class InfoCompte extends StatefulWidget {
  final password;
  InfoCompte({Key key, this.password = ''}) : super(key: key);

  @override
  _InfoCompteState createState() => _InfoCompteState();
}

class _InfoCompteState extends State<InfoCompte> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final RegExp phoneRegex = RegExp(r"^6[0-9]{8}$");
  // final RegExp urlRegex =
  //     RegExp(r"^https://[a-zA-Z0-9\!\^\$\(\)\[\]\{\}\?\+\*\.\/\\|]+$");
  //picture: https://lh3.googleusercontent.com/a/AATXAJyyQijYVdHXSeHK_ufRXE2_xxSuNGUiJZ7zoSJs=s96-c,
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  TextEditingController nameController;
  TextEditingController passwordController;
  TextEditingController urlController;
  TextEditingController telControlleur;

  Color theme = Colors.blue;
  Color color = Colors.grey;
  String uid = '';
  String nomPrenom = '';
  String telephone = '';
  String _password = '';
  bool erreurNom = false;
  bool erreurTel = false;
  bool modifier = false;
  bool _isSecret = true;
  bool erreurMdp = false;
  String modif = '';
  bool isLoading = false;

  User user;

  @override
  void initState() {
    _auth.userChanges().listen((event) => setState(() => {
          user = event,
          nomPrenom = (user.displayName != null) ? user.displayName : '',
          _password = (widget.password != '') ? widget.password : '',
        }));

    super.initState();
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    affiche('Veuillez patienter . . .', Icons.refresh);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          final pickedFile = await _picker.getImage(
            source: source,
          );
          print(pickedFile.path);
          setState(() {
            _imageFile = pickedFile;
          });

          updatePhoto();
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      }
    } on SocketException catch (_) {
      affiche('Veuillez-vous connecter . . .', Icons.signal_wifi_off_rounded);
    }
  }

  Widget _previewImage() {
    try {
      final Text retrieveError = _getRetrieveErrorWidget();
      if (retrieveError != null) {
        return retrieveError;
      }
      if (_imageFile != null) {
        print(_imageFile.path);
        if (kIsWeb) {
          // Why network?
          // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
          print('oui');
          return Container(
            height: 170.0,
            width: 160.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                   _imageFile.path
                ),
                fit: BoxFit.cover,
                onError: (dynamic, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('images/avatar/a1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                  );
                },
              ),
            ),
          );
        } else {
          print('non');
          return Container(
            height: 170.0,
            width: 160.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                   user.photoURL
                ),
                fit: BoxFit.cover,
                onError: (dynamic, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('images/avatar/a1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                  );
                },
              ),
            ),
          );
        }
      } else if (_pickImageError != null) {
        return Text(
          'Erreur de selection de l\'image: $_pickImageError',
          textAlign: TextAlign.center,
        );
      } else {
        return Container(
          height: 170.0,
          width: 160.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(
                  user.photoURL
              ),
              fit: BoxFit.cover,
              onError: (dynamic, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/avatar/a1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      affiche('Une erreur c\'est produite veuillez réesseller ultérieurement ',
          null);
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  Text _getRetrieveErrorWidget() {
    try {
      if (_retrieveDataError != null) {
        final Text result = Text(_retrieveDataError);
        _retrieveDataError = null;
        return result;
      }
      return null;
    } catch (e) {
      affiche('Une erreur c\'est produite veuillez réesseller ultérieurement ',
          null);
    }
  }

  void updatePhoto() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        user.updateProfile(photoURL: _imageFile.path);
      }
    } on SocketException catch (_) {
      affiche('Veuillez-vous connecter . . .', Icons.signal_wifi_off_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: theme,
        title: Text('InfoCompte'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert_outlined),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: GestureDetector(
                  onTap: () {},
                  child: Text('Aide'),
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    if (user.photoURL != ' ' &&
                        user.photoURL != null &&
                        user != null)
                      Positioned(
                          child: GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  user.photoURL
                                ),
                                fit: BoxFit.cover,
                                onError: (dynamic, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage('images/avatar/a1.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        child: _previewImage(),
                      ))
                    else
                      Positioned(
                        child: Container(
                          height: 130.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 3.0,
                              color: Colors.white,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: theme,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 100.0,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 50.0,
                      height: 50.0,
                    ),
                    Positioned(
                      right: 0.0,
                      bottom: 10.0,
                      child: Container(
                        height: 55.0,
                        width: 55.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3.0,
                            color: Colors.white,
                          ),
                        ),
                        child: Semantics(
                          label: 'Selection d\'une image dans la gallery',
                          child: FloatingActionButton(
                            backgroundColor: theme,
                            onPressed: () {
                              _onImageButtonPressed(ImageSource.gallery,
                                  context: context);
                            },
                            heroTag: 'image0',
                            tooltip: 'Selection d\'image',
                            child: const Icon(Icons.photo_camera_rounded),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Nom & Prénom',
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                    ),
                    Container(
                      height: 112.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.white),
                          left: BorderSide(width: 1.0, color: Colors.white),
                          right: BorderSide(width: 1.0, color: Colors.white),
                          bottom: BorderSide(width: 1.0, color: Colors.white),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: TextFormField(
                                        controller: nameController,
                                        autocorrect: false,
                                        initialValue: (user.displayName != null)
                                            ? user.displayName
                                            : 'Votre nom et prénom',
                                        autofocus: modifier,
                                        style: TextStyle(
                                            // fontSize: 20.0,
                                            ),
                                        onChanged: (value) {
                                          if (value.isNotEmpty &&
                                              value.length >= 4) {
                                            setState(() {
                                              nomPrenom = value;
                                              erreurNom = false;
                                            });
                                            if (_password.length >= 6)
                                              setState(() {
                                                color = Colors.blue;
                                              });
                                          } else {
                                            setState(() {
                                              nomPrenom = value;
                                              erreurNom = true;
                                              color = Colors.grey;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.edit, size: 20, color: theme),
                            ],
                          ),
                          if (erreurNom)
                            Text(
                              'Stp Entrer votre Nom et Prenom (> 4 caractères)',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 11.0,
                                height: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Mot de Passe',
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                    ),
                    Container(
                      height: 112.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        border: Border(
                          top: BorderSide(width: 1.0, color: Colors.white),
                          left: BorderSide(width: 1.0, color: Colors.white),
                          right: BorderSide(width: 1.0, color: Colors.white),
                          bottom: BorderSide(width: 1.0, color: Colors.white),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: TextFormField(
                                        controller: passwordController,
                                        onChanged: (value) =>
                                            (value.length >= 6)
                                                ? {
                                                    setState(() {
                                                      _password = value;
                                                      erreurMdp = false;
                                                      print(nomPrenom);
                                                    }),
                                                    if (nomPrenom.length >= 4)
                                                      setState(() {
                                                        color = Colors.blue;
                                                      })
                                                  }
                                                : {
                                                    setState(() {
                                                      _password = value;
                                                      erreurMdp = true;
                                                      color = Colors.grey;
                                                    }),
                                                  },
                                        obscureText: _isSecret,
                                        initialValue: _password,
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap: () => setState(
                                                () => _isSecret = !_isSecret),
                                            child: Icon(
                                                !_isSecret
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.black),
                                          ),
                                          hintText: 'Votre mot de passe',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.edit, size: 20, color: theme),
                            ],
                          ),
                          if (erreurMdp)
                            Text(
                              'Mot de passe trop petit (< 6 caractere)',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 11.0,
                                height: 2,
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
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
                        color: (_password != '' &&
                                nomPrenom != '' &&
                                _password.length >= 6 &&
                                nomPrenom.length >= 4)
                            ? theme
                            : color,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                        ),
                        // onPressed: () => showAlert(context),
                        onPressed: (erreurNom == false &&
                                erreurMdp == false &&
                                nomPrenom.isNotEmpty &&
                                _password.isNotEmpty)
                            ? () async {
                                affiche(
                                    'Veuillez patienter . . .', Icons.refresh);
                                try {
                                  final result = await InternetAddress.lookup(
                                      'google.com');
                                  if (result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    if (user.uid == null) {
                                      uploadFile(_imageFile);
                                    } else {
                                      updateFile(_imageFile);

                                      // print(nomPrenom)
                                    }
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Serie()),
                                        ModalRoute.withName('/serie'));
                                  }
                                } on SocketException catch (_) {
                                  affiche('Veuillez-vous connecter . . .',
                                      Icons.signal_wifi_off_rounded);
                                }
                              }
                            : () => showErrorChamps(context),
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

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile(pickedFile);
    }
  }

  Future uploadFile(PickedFile file) async {
    try {
      if(file == null) {
        user.updateProfile(
            displayName: nomPrenom, photoURL: ' ');
        await _firebaseFirestore
            .collection('utilisateurs')
            .doc(_auth.currentUser.uid)
            .set({
          'nom': nomPrenom,
          'telephone': user.phoneNumber,
          'password': _password,
          'profil': ' ',
          'dateCreate': DateTime.now(),
          'dateUpdate': DateTime.now(),
        }, SetOptions(merge: true)).then(
                (value) => {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder:
                                  (BuildContext
                                      context) {
                        return Serie();
                      }))
                    });
      } else {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".jpeg";
        Reference reference = FirebaseStorage.instance.ref('users').child(user.uid).child('profil').child(fileName);
        final metadata = SettableMetadata(
            contentType: 'image/jpeg', customMetadata: {'picked-file-path': file.path});
        TaskSnapshot snapshot;
        if (kIsWeb) {
          snapshot = await reference.putData(await file.readAsBytes(), metadata);
        } else {
          snapshot = await reference.putFile(File(file.path), metadata);
        }

        String imageUrl = await snapshot.ref.getDownloadURL();
        print(imageUrl);
        user.updateProfile(
            displayName: nomPrenom, photoURL: imageUrl);
        await _firebaseFirestore
            .collection('utilisateurs')
            .doc(_auth.currentUser.uid)
            .set({
          'nom': nomPrenom,
          'telephone': user.phoneNumber,
          'password': _password,
          'profil': imageUrl,
          'dateCreate': DateTime.now(),
          'dateUpdate': DateTime.now(),
        }, SetOptions(merge: true)).then(
                (value) => {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder:
                                  (BuildContext
                                      context) {
                        return Serie();
                      }))
                    });
      }
      
      setState(() {
        isLoading = false;
        // onSendMessage(imageUrl, 1);
      });
    } on Exception {
      setState(() {
        isLoading = false;
      });
      // Fluttertoast.showToast(msg: "Error! Try again!");
      affiche('Veuillez recommencer', Icons.error);
    }
  }

  Future updateFile(PickedFile file) async {
    try{
      if(file == null) {
        user.updateProfile(
            displayName: nomPrenom, photoURL: user.photoURL);
        var doc;
        doc = user.uid;

        //Modification du document
        _firebaseFirestore
            .collection("utilisateurs")
            .doc(doc)
            .update({
          "nom": nomPrenom,
          "password": _password,
          "profil": user.photoURL,
          "dateUpdate": DateTime.now(),
        }).then((value) {
          user.reload();
        });
      } else {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".jpeg";
        Reference reference = FirebaseStorage.instance.ref('users').child(user.uid).child('profil').child(fileName);
        final metadata = SettableMetadata(
            contentType: 'image/jpeg', customMetadata: {'picked-file-path': file.path});
        TaskSnapshot snapshot;
        if (kIsWeb) {
          snapshot = await reference.putData(await file.readAsBytes(), metadata);
        } else {
          snapshot = await reference.putFile(File(file.path), metadata);
        }

        String imageUrl = await snapshot.ref.getDownloadURL();
        user.updateProfile(
            displayName: nomPrenom, photoURL: imageUrl);
        var doc;
        doc = user.uid;

        //Modification du document
        _firebaseFirestore
            .collection("utilisateurs")
            .doc(doc)
            .update({
          "nom": nomPrenom,
          "password": _password,
          "profil": imageUrl,
          "dateUpdate": DateTime.now(),
        }).then((value) {
          user.reload();
        });
      }
    
      setState(() {
        isLoading = false;
        // onSendMessage(imageUrl, 1);
      });
    } on Exception {
      setState(() {
        isLoading = false;
      });
      // Fluttertoast.showToast(msg: "Error! Try again!");
      affiche('Veuillez recommencer', Icons.error);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    urlController.dispose();
    telControlleur.dispose();
    super.dispose();
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

  affiche(text, icon) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          Text(text, style: TextStyle(color: Colors.white)),
        ],
      ),
      backgroundColor: theme,
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
