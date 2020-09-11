import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User {
  final String uid;
  final String email;

  User({this.uid, this.email});
}

class UserDataNotifier extends ChangeNotifier {
  UserData _user;
  List<ClassData> _classes;
  List<Homework> _homeworks;

  UserData get user => _user;
  List<Homework> get homeworks => _homeworks;

  List<ClassData> get classes => _classes;

  set user(UserData name) {
    _user = name;
    notifyListeners();
  }

  set classes(List<ClassData> c) {
    _classes = c;
    notifyListeners();
  }

  set homeworks(List<Homework> h) {
    _homeworks = h;
    notifyListeners();
  }

  Future<void> getTheUserHomeworks() async {}

  Future<void> addClassesToUser(List<String> classesPassed, String uid) async {
    bool sameClassFound = false;
    for (String c in classesPassed) {
      //search for first class
      for (String uc in user.classes) {
        if (c == uc) {
          sameClassFound = true;
          // print("TRIED TO ADD A CLASS THAT THE USER ALREADY HAS");
        }
      }
      if (sameClassFound == false) {
        //add this class "c" to the users database
        // print("CLASS BEING ADDED");
        await Firestore.instance.collection("Tutors").document(uid).updateData({
          "classes": FieldValue.arrayUnion([c])
        });
        notifyListeners();
      } else {
        sameClassFound = false;
      }
    }
  }

  Future<void> getTheUserClasses() async {
    List<ClassData> _classList = List<ClassData>();

    for (String c in user.classes) {
      DocumentSnapshot classsnapshot =
          await Firestore.instance.collection("Classes").document(c).get();

      final data =
          ClassData.fromUserMap(classsnapshot.data, classsnapshot.documentID);

      if (data != null) {
        _classList.add(data);
      }
    }

    notifyListeners();

    classes = _classList;
  }

  Future<void> getTheUser(String uid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection("Tutors").document(uid).get();
    // print(uid);
    // print("UID OF THE TUTOR");

    user = UserData.fromMap(snapshot.data);
    notifyListeners();
  }
}

class UserData {
  String uid;
  String firstName;
  int rating;
  List<String> classes;
  List<ClassData> classList = List<ClassData>();

  UserData.fromMap(Map<String, dynamic> data) {
    firstName = data['firstname'] ?? "";
    rating = data['rating'] ?? "";
    classes = data['classes'].cast<String>() ?? "";
  }

  // Stream<UserData> get userdata {
  //   Stream<ClassData> d = Firestore.instance
  //         .collection("Classes")
  //         .document(c)
  //         .snapshots()
  //         .map((event) => ClassData.fromUserMap(event.data, event.documentID));
  // }

  // Stream<UserData> get userdata {
  //   FirebaseAuth.instance.currentUser().then((value) {
  //     return Firestore.instance
  //         .collection("Tutors")
  //         .document(value.uid)
  //         .snapshots()
  //         .map((event) => UserData.fromMap(event.data));
  //   });
  // }

  List<ClassData> get cs => classList;

  set cs(List<ClassData> s) {
    cs = s;
  }

  Future get getTheUserClasses async {
    for (String c in classes) {
      DocumentSnapshot classsnapshot =
          await Firestore.instance.collection("Classes").document(c).get();

      final data =
          ClassData.fromUserMap(classsnapshot.data, classsnapshot.documentID);

      if (data != null) {
        classList.add(data);
        // print(data.classdescription);
      }
    }

    cs = classList;
  }

  UserData({this.firstName, this.rating, this.classes});
}

class Tutor with ChangeNotifier {
  String firstName;
  final int rating;
  final String docid;
  final int rate;
  final List<String> classes;

  Tutor({this.firstName, this.rating, this.docid, this.classes, this.rate});
}

final List<String> classes = ["CSCE 2100", "CSCE 2110", "Automata Theory"];

class AllClassesData {
  final List<String> notes;
  final List<String> homework;
  final List<String> tests;

  AllClassesData({this.notes, this.homework, this.tests});
}

class ClassDataNotifier extends ChangeNotifier {
  List<ClassData> _classList;
  ClassData _currentClass;
  Stream<List<Homework>> thehomework;
  Stream<List<Note>> _notes;
  Stream<List<Test>> _tests;

  UnmodifiableListView<ClassData> get classList =>
      UnmodifiableListView(_classList);

  ClassData get currentClass => _currentClass;

  List<ClassData> get classes => _classList;

  // List<Homework> get homework => _homework;
  // List<Note> get notes => _notes;

  set homework(Stream<List<Homework>> s) {
    thehomework = s;
    notifyListeners();
  }

  set tests(Stream<List<Test>> s) {
    _tests = s;
    notifyListeners();
  }

  set notes(Stream<List<Note>> s) {
    _notes = s;
    notifyListeners();
  }

  Stream<List<Note>> get notes {
    return Firestore.instance
        .collection("Classes")
        .document(_currentClass.classid)
        .collection("Notes")
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Note.fromMap(e.data)).toList());
  }

  Stream<List<Test>> get tests {
    return Firestore.instance
        .collection("Classes")
        .document(_currentClass.classid)
        .collection("Tests")
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Test.fromMap(e.data)).toList());
  }

  Stream<List<Homework>> get homework {
    // print(_currentClass.classid);
    return Firestore.instance
        .collection("Classes")
        .document(_currentClass.classid)
        .collection("Homework")
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Homework.fromMap(e.data)).toList());
  }

  // Future<void> getTheHomeworks() async {
  //   // print("INSIDE THE GET HOMEWORK METHOD");
  //   // print(_currentClass.classid);
  //   QuerySnapshot snapshot = await Firestore.instance
  //       .collection("Classes")
  //       .document(_currentClass.classid)
  //       .collection("Homework")
  //       .getDocuments();

  //   List<Homework> _homeworkList = List<Homework>();

  //   await Future.forEach(snapshot.documents, (document) async {
  //     Homework homeworkData = Homework.fromMap(document.data);

  //     if (homeworkData != null) {
  //       _homeworkList.add(homeworkData);
  //     } else {
  //       print("SOMETHING WENT WRONG");
  //     }
  //   });

  //   notifyListeners();

  //   homework = _homeworkList;
  // }

  // Future<void> getTheNotes() async {
  //   QuerySnapshot snapshot = await Firestore.instance
  //       .collection("Classes")
  //       .document(_currentClass.classid)
  //       .collection("Notes")
  //       .getDocuments();

  //   List<Note> _notesList = List<Note>();

  //   await Future.forEach(snapshot.documents, (document) async {
  //     Note noteData = Note.fromMap(document.data);

  //     if (noteData != null) {
  //       _notesList.add(noteData);
  //     } else {
  //       print("SOMETHING WENT WRONG");
  //     }
  //   });

  //   notifyListeners();

  //   notes = _notesList;
  // }

  // Future<void> getTheTests() async {
  //   QuerySnapshot snapshot = await Firestore.instance
  //       .collection("Classes")
  //       .document(_currentClass.classid)
  //       .collection("Tests")
  //       .getDocuments();

  //   List<Test> _testsLists = List<Test>();

  //   await Future.forEach(snapshot.documents, (document) async {
  //     Test testData = Test.fromMap(document.data);

  //     if (testData != null) {
  //       _testsLists.add(testData);
  //     } else {
  //       print("SOMETHING WENT WRONG");
  //     }
  //   });

  //   notifyListeners();

  //   tests = _testsLists;
  // }

  Future<void> getTheClasses() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection("Classes").getDocuments();

    List<ClassData> _classList = List<ClassData>();

    await Future.forEach(snapshot.documents, (document) async {
      // ClassData data = ClassData.fromMap(document.data);
      QuerySnapshot pre = await Firestore.instance
          .collection("Classes")
          .document(document.documentID)
          .collection("Pre")
          .getDocuments();

      List<Preq> _preList = List<Preq>();

      pre.documents.forEach((preClass) {
        Preq preqData = Preq.fromMap(preClass.data);

        if (preClass.data != null) {
          _preList.add(preqData);
        }
      });

      ClassData data =
          ClassData.fromMap(document.data, document.documentID, _preList);

      // print("BIG FAT ONE");
      // print(document.data);
      if (data != null) {
        _classList.add(data);
      }
    });

    notifyListeners();

    classes = _classList;
  }

  set classes(List<ClassData> s) {
    _classList = s;
    notifyListeners();
  }

  set currentClass(ClassData s) {
    _currentClass = s;
  }

  void onChange() {
    notifyListeners();
  }

  // ClassData({this.classname, this.classdescription});
}

class Preq {
  String classname;
  int etc;

  Preq.fromMap(Map<String, dynamic> data) {
    classname = data['Class'];
    etc = data['etc'];
  }

  Preq({this.classname});
}

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

class UserClassData {
  String documentID;
  String classname;
  String classdescription;
  List<Preq> preq;

  List<Homework> homeworks;
  List<Note> notes;
  List<Test> tests;

  UserClassData.fromUserMap(Map<String, dynamic> data, String docID) {
    classname = data['Title'] ?? "";
    classdescription = data['Description'] ?? "";
    documentID = docID;
  }

  UserClassData.fromMap(Map<String, dynamic> data, String docID, List<Preq> p,
      List<Homework> homeworks, List<Note> notes, List<Test> tests) {
    classname = data['Title'] ?? "";
    classdescription = data['Description'] ?? "";
    documentID = docID;

    print("HERE");
    print(p[0].classname);
    preq = p;
    this.homeworks = homeworks;
    this.notes = notes;
    this.tests = tests;
  }
}

class ClassData {
  String documentID;
  String classname;
  String classdescription;
  List<Preq> preq;
  String classid;
  bool picked = false;
  ClassData currentClass;

  List<Homework> homeworks;
  List<Note> notes;
  List<Test> tests;
  // List notes;
  // List tests;

  ClassData({
    this.documentID,
    this.classname,
    this.classdescription,
    this.classid,
  });

  ClassData.fromUserMap(Map<String, dynamic> data, String docID) {
    classname = data['Title'] ?? "";
    classdescription = data['Description'] ?? "";
    documentID = docID;
    classid = data['classid'];
  }

  ClassData.fromMap(Map<String, dynamic> data, String docID, List<Preq> p) {
    classname = data['Title'] ?? "";
    classdescription = data['Description'] ?? "";
    documentID = docID;
    classid = data['classid'];

    preq = p;
  }
}

List<String> takenClasses = [];

List<String> selectedUserClasses = [];
