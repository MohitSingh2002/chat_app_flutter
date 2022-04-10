import 'package:chat_app_flutter/constants/constant_colors.dart';
import 'package:chat_app_flutter/constants/constants.dart';
import 'package:chat_app_flutter/constants/utils.dart';
import 'package:chat_app_flutter/helpers/firestore_helper.dart';
import 'package:chat_app_flutter/models/message.dart';
import 'package:chat_app_flutter/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {

  Profile currentUserProfile, profile;

  ChatScreen({required this.currentUserProfile, required this.profile});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.purple_bg,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ConstantColors.purple_light,
        iconTheme: IconThemeData(
          color: ConstantColors.white,
        ),
        title: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  backgroundColor: ConstantColors.purple_light,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name : ${widget.profile.name}',
                        style: TextStyle(
                          color: ConstantColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: Utils.width(context) / 50.0,
                      ),
                      Text(
                        'Email : ${widget.profile.email}',
                        style: TextStyle(
                          color: ConstantColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: Utils.width(context) / 50.0,
                      ),
                      Text(
                        'Phone Number : ${widget.profile.phoneNumber}',
                        style: TextStyle(
                          color: ConstantColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: ConstantColors.red,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Text(
            '${widget.profile.name}',
            style: TextStyle(
              color: ConstantColors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection(Constants.profile).doc(widget.currentUserProfile.uid).collection(Constants.messages).doc(widget.profile.uid).collection(Constants.message).orderBy(Constants.timestamp, descending: true,).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ConstantColors.red,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(Utils.width(context) / 50.0,),
                      child: ListView.separated(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Message message = Message.fromJson(snapshot.data!.docs.elementAt(index).data() as Map<String, dynamic>);
                          return Align(
                            alignment: message.isSend ? Alignment.topRight : Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.all(Utils.width(context) / 50.0,),
                              decoration: BoxDecoration(
                                color: message.isSend ? ConstantColors.purple_light : ConstantColors.red,
                                borderRadius: message.isSend ? BorderRadius.only(
                                  topLeft: Radius.circular(Utils.width(context) / 50.0,),
                                  topRight: Radius.circular(Utils.width(context) / 50.0,),
                                  bottomLeft: Radius.circular(Utils.width(context) / 50.0,),
                                ) : BorderRadius.only(
                                  topLeft: Radius.circular(Utils.width(context) / 50.0,),
                                  topRight: Radius.circular(Utils.width(context) / 50.0,),
                                  bottomRight: Radius.circular(Utils.width(context) / 50.0,),
                                ),
                              ),
                              child: Text(
                                '${message.message}',
                                style: TextStyle(
                                  color: ConstantColors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: Utils.width(context) / 30.0,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            buildTextFieldForSendingMessage(),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldForSendingMessage() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(Utils.width(context) / 50.0,),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                style: TextStyle(
                  color: ConstantColors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your message.....',
                  hintStyle: TextStyle(
                    color: ConstantColors.grey,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ConstantColors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ConstantColors.white,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Message message = Message(
                  message: messageController.text.toString(),
                  isSend: true,
                  timestamp: Timestamp.now(),
                );
                FirestoreHelper().sendMessage(message: message, currentUserProfile: widget.currentUserProfile, profile: widget.profile);
                setState(() {
                  messageController = TextEditingController();
                });
              },
              icon: Icon(Icons.send, color: ConstantColors.white,),
            ),
          ],
        ),
      ),
    );
  }

}
