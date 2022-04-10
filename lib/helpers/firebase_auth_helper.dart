import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper {

  Future<String> registerUser({required String email, required String password}) async {
    var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return user.user!.uid;
  }

  Future<UserCredential> authenticateUser({required String email, required String password}) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    return await FirebaseAuth.instance.signOut();
  }

}
