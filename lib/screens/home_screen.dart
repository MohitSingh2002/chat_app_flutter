import 'package:chat_app_flutter/constants/constant_colors.dart';
import 'package:chat_app_flutter/constants/constants.dart';
import 'package:chat_app_flutter/constants/utils.dart';
import 'package:chat_app_flutter/helpers/firebase_auth_helper.dart';
import 'package:chat_app_flutter/helpers/shared_prefs_helper.dart';
import 'package:chat_app_flutter/models/profile.dart';
import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoading = false;
  Profile? profileFromPrefs;

  @override
  void initState() {
    super.initState();
    getFromSharedPrefs();
  }

  void getFromSharedPrefs() {
    setState(() {
      isLoading = true;
    });
    SharedPrefsHelper().getProfile().then((profile) {
      setState(() {
        profileFromPrefs = profile;
        isLoading = false;
      });
    }).catchError((onError) {
      print('onError : ${onError.toString()}');
      Utils.showToast(message: 'Some error occurred, please restart app or try again later');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.purple_bg,
      appBar: AppBar(
        backgroundColor: ConstantColors.purple_light,
        title: Text(
          'Chats',
          style: TextStyle(
            color: ConstantColors.white,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              SharedPrefsHelper().clearAll();
              FirebaseAuthHelper().logout().then((value) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
              });
            },
            icon: Icon(Icons.exit_to_app, color: ConstantColors.white,),
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading ? Center(
          child: CircularProgressIndicator(
            color: ConstantColors.red,
          ),
        ) : StreamBuilder(
          stream: FirebaseFirestore.instance.collection(Constants.profile).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: ConstantColors.red,
                ),
              );
            } else {
              if (profileFromPrefs == null) {
                return Container();
              }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: Utils.width(context) / 50, vertical: Utils.height(context) / 80,),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Profile profile = Profile.fromJson(snapshot.data!.docs.elementAt(index).data() as Map<String, dynamic>);
                    if (profile.email == profileFromPrefs!.email) {
                      return Container(
                        width: 0.0,
                        height: 0.0,
                      );
                    }
                    return Card(
                      color: ConstantColors.purple_light,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(currentUserProfile: profileFromPrefs!, profile: profile)));
                        },
                        leading: CircleAvatar(
                          backgroundColor: ConstantColors.purple_light_2,
                          child: FlutterLogo(),
                        ),
                        title: Text(
                          '${profile.name}',
                          style: TextStyle(
                            color: ConstantColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    Profile profile = Profile.fromJson(snapshot.data!.docs.elementAt(index).data() as Map<String, dynamic>);
                    if (profile.email == profileFromPrefs!.email) {
                      return Container(
                        width: 0.0,
                        height: 0.0,
                      );
                    }
                    return SizedBox(
                      height: Utils.height(context) / 80,
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
