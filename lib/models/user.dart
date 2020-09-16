import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'classMaterialModel.dart';

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

  Future<void> deleteClassesNotPicked(
      List<String> classNotPassed, String uid) async {
    for (String c in classNotPassed) {
      //search for first class
      for (String uc in user.classes) {
        if (c == uc) {
          var val = [];
          var valTwo = [];
          //remove the classid from the user
          await Firestore.instance
              .collection("Tutors")
              .document(uid)
              .get()
              .then((value) {
            val = value.data['classes'];
            val.remove(c);
            // val.removeWhere((element) => (element == c));
            // print(val);

            Firestore.instance
                .collection("Tutors")
                .document(uid)
                .updateData({"classes": val});
          });
          //remove the uid from the class
          await Firestore.instance
              .collection("Classes")
              .document(c)
              .get()
              .then((value) {
            valTwo = value.data['tutors'];
            valTwo.remove(uid);
            Firestore.instance
                .collection("Classes")
                .document(c)
                .updateData({"tutors": valTwo});
          });
          print(c);
        }
      }
    }

    notifyListeners();
  }

  Future<void> addClassesToUser(List<String> classesPassed, String uid) async {
    bool sameClassFound = false;
    for (String c in classesPassed) {
      //search for first class
      // print(c);
      for (String uc in user.classes) {
        if (c == uc) {
          sameClassFound = true;
          // print("TRIED TO ADD A CLASS THAT THE USER ALREADY HAS");
        }
      }
      if (sameClassFound == false) {
        //add this class "c" to the users database
        print(c);

        await Firestore.instance.collection("Tutors").document(uid).updateData({
          "classes": FieldValue.arrayUnion([c])
        });
        await Firestore.instance.collection("Classes").document(c).updateData({
          "tutors": FieldValue.arrayUnion([uid]) ?? [uid]
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
        data.picked = true;
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
      }
    }

    cs = classList;
  }

  UserData.fromTestMap({this.uid});
  UserData({this.firstName, this.rating, this.classes});
}

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
  UserData _user;

  UnmodifiableListView<ClassData> get classList =>
      UnmodifiableListView(_classList);

  ClassData get currentClass => _currentClass;

  List<ClassData> get classes => _classList;

  String uid;

  UserData get user => _user;

  ClassDataNotifier({this.uid});

  set user(UserData name) {
    _user = name;
    notifyListeners();
  }

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

  Future<void> getTheUser(String uid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection("Tutors").document(uid).get();

    user = UserData.fromMap(snapshot.data);
    notifyListeners();
  }

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

      for (String c in user.classes) {
        DocumentSnapshot classsnapshot =
            await Firestore.instance.collection("Classes").document(c).get();
        print("HERERED");

        if (c == data.classid) {
          data.picked = true;
        }
      }

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

  Stream<List<Homework>> homeworks;
  Stream<List<Note>> notesList;
  Stream<List<Test>> testsList;

  set homework(Stream<List<Homework>> s) {
    homeworks = s;
  }

  set tests(Stream<List<Test>> s) {
    testsList = s;
  }

  set notes(Stream<List<Note>> s) {
    notesList = s;
  }

  Stream<List<Homework>> get homework {
    // final Firestore _firestore = Firestore.instance;
    return Firestore.instance
        .collection("Classes")
        .document(classid)
        .collection("Homework")
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Homework.fromMap(e.data)).toList());
  }

  Stream<List<Note>> get notes {
    // final Firestore _firestore = Firestore.instance;
    return Firestore.instance
        .collection("Classes")
        .document(classid)
        .collection("Notes")
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Note.fromMap(e.data)).toList());
  }

  Stream<List<Test>> get tests {
    // final Firestore _firestore = Firestore.instance;
    return Firestore.instance
        .collection("Classes")
        .document(classid)
        .collection("Tests")
        .snapshots()
        .map((event) =>
            event.documents.map((e) => Test.fromMap(e.data)).toList());
  }

  ClassData({
    this.documentID,
    this.classname,
    this.classdescription,
    this.classid,
  });

  ClassData.fromUserMapStream(
      Map<String, dynamic> data, String docID, String uid) {
    classname = data['Title'] ?? "";
    classdescription = data['Description'] ?? "";
    documentID = docID;
    classid = data['classid'];

    List<String> tutorIds = data['tutors'].cast<String>();
    if (tutorIds.contains(uid)) {
      picked = true;
    } else {
      picked = false;
    }
  }

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
