import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.message,
    required this.isSend,
    required this.timestamp,
  });

  String message;
  bool isSend;
  Timestamp timestamp;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    message: json["message"],
    isSend: json["isSend"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "isSend": isSend,
    "timestamp": timestamp,
  };

  @override
  String toString() {
    return 'Message{message: $message, isSend: $isSend, timestamp: ${timestamp.toDate().toString()}}';
  }

}
