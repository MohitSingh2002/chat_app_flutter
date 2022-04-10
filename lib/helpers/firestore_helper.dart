import 'package:chat_app_flutter/constants/constants.dart';
import 'package:chat_app_flutter/constants/exceptions.dart';
import 'package:chat_app_flutter/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {

  Future<Profile> getProfile(String email) async {
    var snapshot = await FirebaseFirestore.instance.collection(Constants.profile).where(Constants.email, isEqualTo: email).get();
    if (snapshot.size > 0) {
      return Profile.fromJson(snapshot.docs.elementAt(0).data());
    } else {
      throw Exceptions.user_not_found;
    }
  }

  Future<void> setProfile(Profile profile) async {
    return await FirebaseFirestore.instance
        .collection(Constants.profile)
        .doc(profile.uid)
        .set(profile.toJson(), SetOptions(merge: true,));
  }

}
