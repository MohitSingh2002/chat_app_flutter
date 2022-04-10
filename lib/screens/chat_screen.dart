import 'package:chat_app_flutter/constants/constant_colors.dart';
import 'package:chat_app_flutter/models/profile.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  Profile currentUserProfile, profile;

  ChatScreen({required this.currentUserProfile, required this.profile});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.purple_bg,
      appBar: AppBar(
        backgroundColor: ConstantColors.purple_light,
        iconTheme: IconThemeData(
          color: ConstantColors.white,
        ),
        title: Text(
          '${widget.profile.name}',
          style: TextStyle(
            color: ConstantColors.white,
          ),
        ),
      ),
    );
  }
}
