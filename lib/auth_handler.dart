import 'package:chat_app_flutter/screens/home_screen.dart';
import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHandler {

  handleAuth() {
    if (FirebaseAuth.instance.currentUser == null) {
      // Navigate to login screen
      return LoginScreen();
    } else {
      // Navigate to home screen
      return HomeScreen();
    }
  }

}
