import 'package:chat_app_flutter/constants/constants.dart';
import 'package:chat_app_flutter/constants/exceptions.dart';
import 'package:chat_app_flutter/models/message.dart';
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

  Future<void> sendMessage({required Message message, required Profile currentUserProfile, required Profile profile}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference senderDocRef = FirebaseFirestore.instance.collection(Constants.profile).doc(currentUserProfile.uid).collection(Constants.messages).doc(profile.uid);
    batch.set(senderDocRef, {'uid': profile.uid}, SetOptions(merge: true));

    DocumentReference messageDocRefForSender = FirebaseFirestore.instance.collection(Constants.profile).doc(currentUserProfile.uid).collection(Constants.messages).doc(profile.uid).collection(Constants.message).doc();
    batch.set(messageDocRefForSender, message.toJson(), SetOptions(merge: true,));

    message.isSend = false;

    DocumentReference receiverDocRef = FirebaseFirestore.instance.collection(Constants.profile).doc(profile.uid).collection(Constants.messages).doc(currentUserProfile.uid);
    batch.set(receiverDocRef, {'uid': currentUserProfile.uid}, SetOptions(merge: true));

    DocumentReference messageDocRefForReceiver = FirebaseFirestore.instance.collection(Constants.profile).doc(profile.uid).collection(Constants.messages).doc(currentUserProfile.uid).collection(Constants.message).doc();
    batch.set(messageDocRefForReceiver, message.toJson(), SetOptions(merge: true,));

    return batch.commit();
  }

}
