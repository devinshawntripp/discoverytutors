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

class Preq {
  String classname;
  int etc;

  Preq.fromMap(Map<String, dynamic> data) {
    classname = data['Class'];
    etc = data['etc'];
  }

  Preq({this.classname});
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

List<String> takenClasses = [''];

List<String> selectedUserClasses = [];
