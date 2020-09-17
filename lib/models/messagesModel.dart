import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String content;
  String idfrom;
  Timestamp timeStamp;
  String type;

  Message.fromMap(Map<String, dynamic> data) {
    this.content = data['content'];
    this.idfrom = data['idfrom'];
    this.timeStamp = data['timeStamp'];
    this.type = data['type'];
  }
}
