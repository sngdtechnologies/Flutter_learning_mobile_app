import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:premiere/screens/Loading.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:premiere/widgets/navbar.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Profil extends StatefulWidget {
  Profil({Key key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
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
  TextEditingController urlController;
  TextEditingController telControlleur;

  Color theme = Colors.deepPurple;
  String uid = '';
  String nomPrenom = '';
  String telephone = '';
  bool erreurNom = false;
  bool erreurTel = false;
  bool modifier = false;
  String modif = '';

  User user;

  @override
  void initState() {
    _auth.userChanges().listen((event) => setState(() => {user = event}));
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
    print(user.photoURL);
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

  void updateNameTel() async {
    affiche('Veuillez patienter . . .', Icons.refresh);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (modif == 'nom') {
          user.updateProfile(displayName: nomPrenom);
          var doc;
          // var result = await _firebaseFirestore
          //     .collection("utilisateurs")
          //     .where("nom", isEqualTo: user.displayName)
          //     .get();
          doc = user.uid;

          //Modification du document
          _firebaseFirestore
              .collection("utilisateurs")
              .doc(doc)
              .update({"nom": nomPrenom}).then((value) {
            setState(() {
              modifier = false;
            });
            user.reload();
          });

          // print(nomPrenom)
        } else {
          print(telephone);
          // user.updateProfile(displayName: nomPrenom);
        }
      }
    } on SocketException catch (_) {
      affiche('Veuillez-vous connecter . . .', Icons.signal_wifi_off_rounded);
    }
  }

  void updatePhoto() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".jpeg";
        Reference reference = FirebaseStorage.instance.ref('users').child(user.uid).child('profil').child(fileName);
        final metadata = SettableMetadata(
            contentType: 'image/jpeg', customMetadata: {'picked-file-path': _imageFile.path});
        TaskSnapshot snapshot;
        if (kIsWeb) {
          snapshot = await reference.putData(await _imageFile.readAsBytes(), metadata);
        } else {
          snapshot = await reference.putFile(File(_imageFile.path), metadata);
        }
        
        String imageUrl = await snapshot.ref.getDownloadURL();
        user.updateProfile(photoURL: imageUrl);
        var doc;
        doc = user.uid;

        //Modification du document
        _firebaseFirestore
            .collection("utilisateurs")
            .doc(doc)
            .update({
          "profil": imageUrl,
          "dateUpdate": DateTime.now(),
        }).then((value) {
          user.reload();
        });
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
      appBar: Navbar(
        titre: 'Profil',
        icon: Icons.arrow_back_ios_rounded,
        theme: theme,
        scaffoldKey: scaffoldKey,
      ),
      drawer: ArgonDrawer(currentPage: "Profil"),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    if (user.photoURL != ' ' && user.photoURL != null)
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
                GestureDetector(
                  onTap: () => {
                    setState(() {
                      modifier = true;
                      modif = 'nom';
                    })
                    // print(user)
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.person, size: 20, color: theme),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Nom & Pénom',
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    user.displayName == null
                                        ? 'Pas de Nom'
                                        : user.displayName,
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            )),
                        Icon(Icons.edit, size: 20, color: theme),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    setState(() {
                      modifier = true;
                      modif = 'tel';
                    })
                    // print(user)
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.phone_android_rounded,
                            size: 20, color: theme),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Téléphone',
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    user.phoneNumber == null ||
                                            user.phoneNumber == ''
                                        ? 'Pas de Numero'
                                        : user.phoneNumber,
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            )),
                        Icon(Icons.edit, size: 20, color: theme),
                      ],
                    ),
                  ),
                ),
                if (modifier == true)
                  Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 198.0,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          modif == 'nom'
                                              ? 'Nom & Prénom'
                                              : 'Téléphone',
                                          style: TextStyle(
                                              letterSpacing: 1,
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Container(
                                        child: TextFormField(
                                          controller: modif == 'nom'
                                              ? nameController
                                              : telControlleur,
                                          autocorrect: false,
                                          initialValue: modif == 'nom'
                                              ? user.displayName
                                              : user.phoneNumber,
                                          autofocus: modifier,
                                          style: TextStyle(
                                              // fontSize: 20.0,
                                              ),
                                          onChanged: (value) {
                                            if (modif == 'nom') {
                                              if (value.isNotEmpty &&
                                                  value.length >= 4) {
                                                setState(() {
                                                  nomPrenom = value;
                                                  erreurNom = false;
                                                });
                                              } else {
                                                setState(() {
                                                  erreurNom = true;
                                                });
                                              }
                                            } else {
                                              if (value.isNotEmpty &&
                                                  phoneRegex.hasMatch(value)) {
                                                setState(() {
                                                  telephone = value;
                                                  erreurTel = false;
                                                });
                                              } else {
                                                setState(() {
                                                  erreurTel = true;
                                                });
                                              }
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
                            if (erreurNom || erreurTel)
                              Text(
                                erreurNom
                                    ? 'Stp Entrer votre Nom et Prenom (> 4 caractères)'
                                    : 'Numero Ivalide ( < 9 chiffres)',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 11.0,
                                  height: 2,
                                ),
                              ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                  color: theme,
                                  onPressed: () => setState(() {
                                    modifier = false;
                                  }),
                                  child: Text(
                                    'Annuler',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  color: theme,
                                  onPressed: () => updateNameTel(),
                                  child: Text(
                                    'Modifier',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    urlController.dispose();
    telControlleur.dispose();
    super.dispose();
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
