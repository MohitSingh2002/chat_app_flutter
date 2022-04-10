import 'package:chat_app_flutter/constants/constant_colors.dart';
import 'package:chat_app_flutter/constants/exceptions.dart';
import 'package:chat_app_flutter/constants/utils.dart';
import 'package:chat_app_flutter/helpers/firebase_auth_helper.dart';
import 'package:chat_app_flutter/helpers/firestore_helper.dart';
import 'package:chat_app_flutter/helpers/shared_prefs_helper.dart';
import 'package:chat_app_flutter/screens/home_screen.dart';
import 'package:chat_app_flutter/screens/sign_up_screen.dart';
import 'package:chat_app_flutter/widgets/text_field_custom.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordNotVisible = true;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.purple_bg,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Center(
            child: isLoading ? CircularProgressIndicator(
              color: ConstantColors.red,
            ) : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Utils.width(context) / 20, vertical: Utils.height(context) / 30,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        color: ConstantColors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: Utils.width(context) / 15,
                    ),
                    Card(
                      color: ConstantColors.purple_light,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Utils.width(context) / 50,),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Utils.width(context) / 20, vertical: Utils.height(context) / 20,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFieldCustom(
                              controller: emailController,
                              hintText: 'Enter email',
                              keyboardType: TextInputType.emailAddress,
                              icon: Icons.email,
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Email can\'t be empty';
                                  } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return 'Please enter correct email';
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: Utils.width(context) / 30,
                            ),
                            TextFieldCustom(
                              controller: passwordController,
                              hintText: 'Enter password',
                              keyboardType: TextInputType.visiblePassword,
                              icon: Icons.lock,
                              obscureText: isPasswordNotVisible,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordNotVisible = !isPasswordNotVisible;
                                  });
                                },
                                icon: FaIcon(isPasswordNotVisible ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, color: ConstantColors.white,),
                              ),
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Password can\'t be empty';
                                  } else if (value.length < 6) {
                                    return 'Password length must be 6';
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: Utils.width(context) / 10,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    FirestoreHelper().getProfile(emailController.text).then((profile) {
                                      FirebaseAuthHelper().authenticateUser(email: emailController.text, password: passwordController.text).then((value) {
                                        SharedPrefsHelper().saveProfile(profile);
                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false,);
                                        // setState(() {
                                        //   isLoading = false;
                                        // });
                                      });
                                    }).catchError((onError) {
                                      if (onError.toString() == Exceptions.user_not_found) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Utils.showToast(message: 'Profile not found, please sign up');
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Utils.showToast(message: 'Some error occurred, please try again later');
                                      }
                                    });
                                  }
                                },
                                child: Text('LOGIN'),
                                style: ElevatedButton.styleFrom(
                                  primary: ConstantColors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Utils.width(context) / 10,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: ConstantColors.white,
                          fontSize: 20.0,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: ConstantColors.red,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
