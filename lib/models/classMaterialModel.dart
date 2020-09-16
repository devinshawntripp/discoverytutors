class Homework {
  String image;
  String uid;
  int rank;
  int upvotes;
  int downvotes;
  String docid;
  String filename;

  Homework.fromMap(Map<String, dynamic> data) {
    // print("some data");
    // print(data);
    image = data['Image'] ?? "";
    uid = data['uid'] ?? "";
    rank = data['rank'] ?? 0;
    upvotes = data['upvotes'] ?? 0;
    downvotes = data['downvotes'] ?? 0;
    docid = data['docid'] ?? "";
    filename = data['filename'] ?? "";
  }
}

class Note {
  String image;
  String uid;
  int rank;
  int upvotes;
  int downvotes;
  String docid;
  String filename;

  Note.fromMap(Map<String, dynamic> data) {
    image = data['Image'] ?? "";
    uid = data['uid'] ?? "";
    rank = data['rank'] ?? 0;
    upvotes = data['upvotes'] ?? 0;
    downvotes = data['downvotes'] ?? 0;
    docid = data['docid'] ?? "";
    filename = data['filename'] ?? "";
  }
}

class Test {
  String image;
  String uid;
  int rank;
  int upvotes;
  int downvotes;
  String docid;
  String filename;

  Test.fromMap(Map<String, dynamic> data) {
    image = data['Image'] ?? "";
    uid = data['uid'] ?? "";
    rank = data['rank'] ?? 0;
    upvotes = data['upvotes'] ?? 0;
    downvotes = data['downvotes'] ?? 0;
    docid = data['docid'] ?? "";
    filename = data['filename'] ?? "";
  }
}
