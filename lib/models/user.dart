class AppUser {
  final String uid;

  AppUser(this.uid);
}

class AppUserData {
  final String uid;
  final String profil;
  final String nom;
  final String recentMsg;
  final int unRead;
  final String timestamps;

  AppUserData({this.uid, this.profil, this.nom, this.recentMsg, this.unRead, this.timestamps});

  Map<String, dynamic> data() {
    return {
      'uid': uid,
      'profil': profil,
      'nom': nom,
      'recent_msg': recentMsg,
      'unRead': unRead,
      'timestamps': timestamps,
    };
  }

  factory AppUserData.fromMap(Map<String, dynamic> data){
    return AppUserData(
        uid: data['uid'],
        profil: data['profil'],
        nom: data['nom'],
        recentMsg: data['recent_msg'],
        unRead: data["unRead"],
        timestamps: data['timestamps'],
    );
  } 
}