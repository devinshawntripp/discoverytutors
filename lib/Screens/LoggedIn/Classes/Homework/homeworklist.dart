import 'dart:io';

import 'package:disc_t/Screens/LoggedIn/Classes/Homework/homeworklistpage.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/Homework/homeworkrowbox.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class HomeworkList extends StatefulWidget {
  final List<dynamic> homenotetest;
  final String name;

  HomeworkList({Key key, this.homenotetest, this.name}) : super(key: key);

  @override
  _HomeworkListState createState() => _HomeworkListState();
}

class _HomeworkListState extends State<HomeworkList> {
  File img;

  final _database = DatabaseService();
  String imageLocation;

  //sets the image
  Future<File> _setImage(BuildContext context) async {
    img = File(await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .then((pickedFile) => pickedFile.path));

    await uploadFile();

    return img;
  }

  @override
  void initState() {
    Provider.of<ClassDataNotifier>(context, listen: false).getTheHomeworks();
    Provider.of<ClassDataNotifier>(context, listen: false).getTheNotes();
    Provider.of<ClassDataNotifier>(context, listen: false).getTheTests();
    // final user = Provider.of<User>(context);
    // getTheClasses(classdatanotif);

    // var u = FirebaseAuth.instance.currentUser();
    // u.then((value) {
    //   getData(value.uid);
    //   // print("DKJFLD HDEKJF");
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // List<ClassData> cData = Provider.of<List<ClassData>>(context);

    // ClassData classImIn;

    final classDataNotif = context.watch<ClassDataNotifier>();
    // print(d.currentClass.classdescription);

    List<dynamic> list;

    switch (widget.name) {
      case "Homework":
        list = classDataNotif.homework;
        break;
      case "Notes":
        list = classDataNotif.notes;
        break;
      case "Tests":
        list = classDataNotif.tests;
        break;
    }

    return Scaffold(
      backgroundColor: Color(0xff3DDC97),
      appBar: AppBar(
        backgroundColor: Color(0xff7211E0),
        title: Text(widget.name),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            // padding: EdgeInsets.only(top: 5),
            child: ListView.builder(
                itemCount: list.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Hero(
                    tag: list[index],
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MorpheusPageRoute(
                                builder: (context) => HomeworkListPage(
                                      homenotetest: list[index],
                                      imageurl: list[index].image,
                                    ),
                                transitionToChild: true));
                      },
                      child: HomeworkRowBox(
                        homenotetest: list[index],
                      ),
                    ),
                  );
                }),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () async {
              await _setImage(context).then((value) {
                String imageName = path.basename(value.path);

                _database
                    .createHomework(user, imageName, "", 0, 0, 0, imageLocation,
                        classDataNotif.currentClass.classid, widget.name)
                    .then((value) {});

                // _database.fetchClassdata;
              });

              switch (widget.name) {
                case "Homework":
                  classDataNotif.getTheHomeworks();
                  break;
                case "Notes":
                  classDataNotif.getTheNotes();
                  break;
                case "Tests":
                  classDataNotif.getTheTests();
                  break;
              }

              final snackBar = SnackBar(
                content:
                    Text('Success ${path.basename(img.path)} was uploaded'),
                duration: Duration(seconds: 2),
                onVisible: () {},
                behavior: SnackBarBehavior.floating,
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }

  uploadFile() async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child("images/${path.basename(img.path)}");
    StorageUploadTask task = firebaseStorageRef.putFile(img);

    await task.onComplete;
    print("File uploaded");

    await firebaseStorageRef.getDownloadURL().then((fileURL) {
      setState(() {
        imageLocation = fileURL;
      });
    });
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(img, height: 300.0, width: 300.0),
        ],
      ),
    );
  }
}
