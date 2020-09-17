class Message {
  String content;
  String idfrom;
  String timeStamp;
  String type;

  Message.fromMap(Map<String, dynamic> data) {
    this.content = data['content'];
    this.idfrom = data['idfrom'];
    this.timeStamp = data['timeStamp'];
    this.type = data['type'];
  }
}
