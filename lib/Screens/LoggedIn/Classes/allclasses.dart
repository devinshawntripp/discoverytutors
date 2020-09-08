import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/classlist.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllClasses extends StatefulWidget {
  @override
  _AllClassesState createState() => _AllClassesState();
}

class _AllClassesState extends State<AllClasses> {
  @override
  void initState() {
    Provider.of<ClassDataNotifier>(context, listen: false).getTheClasses();
    // final user = Provider.of<User>(context);
    // getTheClasses(classdatanotif);

    // var u = FirebaseAuth.instance.currentUser();
    // u.then((value) {
    //   getData(value.uid);
    //   // print("DKJFLD HDEKJF");
    // });
    super.initState();
  }

  // ignore: non_constant_identifier_names
  Widget _BuildUI(ClassDataNotifier data, double h) {
    if (data.classes == null) {
      return Loading();
    } else if (data.classes.isEmpty) {
      return Text("NO DATA FOUND");
    } else {
      return SizedBox(
          height: h * .5,
          child: ClassList(
            data: data.classes,
            dataNotif: data,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ClassDataNotifier classdatanotif = Provider.of<ClassDataNotifier>(context);
    final d = context.watch<ClassDataNotifier>();

    // List<ClassData> cData = Provider.of<List<ClassData>>(context);
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xff3DDC97),
      appBar: AppBar(
        backgroundColor: Color(0xff46237A),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          // Expanded(child: ClassList())

          Expanded(
            child: _BuildUI(d, h),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: h * .1),
          ),
        ],
      )),
    );
  }
}
