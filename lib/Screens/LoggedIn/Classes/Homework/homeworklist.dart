import 'dart:io';
import 'package:disc_t/Screens/LoggedIn/Classes/Homework/homeworklistpage.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/Homework/homeworkrowbox.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/classMaterialModel.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class HomeworkList extends StatefulWidget {
  final List<dynamic> homenotetest;
  final String name;
  final ClassData classdata;

  HomeworkList({Key key, this.homenotetest, this.name, this.classdata})
      : super(key: key);

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
    super.initState();
  }

  Widget IconConditional(
    String uid,
    List<dynamic> list,
    int index,
    String classid,
    String doctype,
    BuildContext context,
    ClassData classDataNotif,
  ) {
    if (list[index].uid == uid) {
      return IconSlideAction(
        caption: "Delete",
        color: Colors.red,
        icon: Icons.delete,
        onTap: () {
          _database.deleteHomework(list[index].docid, classid, doctype);
          final snackBar = SnackBar(
            content: Text('Success ${doctype} was deleted'),
            duration: Duration(seconds: 2),
            onVisible: () {},
            behavior: SnackBarBehavior.floating,
          );
          Scaffold.of(context).showSnackBar(snackBar);
        },
      );
    }
  }

  Widget buildUI(ClassData classd, List<dynamic> list, UserTutor user,
      BuildContext context, String material) {
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
            // child: Text(""),
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
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        // child: Text(""),
                        child: HomeworkRowBox(
                          homenotetest: list[index],
                          classid: classd.classid,
                          materialName: material,
                        ),
                        actions: <Widget>[
                          IconSlideAction(
                            caption: "Archive",
                            color: Colors.blue,
                            icon: Icons.archive,
                            onTap: () => {},
                          ),
                          IconSlideAction(
                            caption: "Share",
                            color: Colors.blue[300],
                            icon: Icons.share,
                            onTap: () => {},
                          )
                        ],
                        secondaryActions: <Widget>[
                          IconConditional(user.uid, list, index, classd.classid,
                              widget.name, context, classd)
                        ],
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
                        classd.classid, widget.name, user.uid)
                    .then((value) {});

                // _database.fetchClassdata;
              });

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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserTutor>(context);

    switch (widget.name) {
      case "Homework":
        return StreamProvider<List<Homework>>.value(
          value: widget.classdata.homework,
          builder: (context, child) {
            final list = Provider.of<List<Homework>>(context);

            // // final n = Provider.of<List<Homework>>(context);
            // // print(n);
            return list == null
                ? Loading()
                : buildUI(widget.classdata, list, user, context, "Homework");
          },
        );
        break;
      case "Notes":
        return StreamProvider.value(
          value: widget.classdata.notes,
          builder: (context, child) {
            final list = Provider.of<List<Note>>(context);
            return list == null
                ? Loading()
                : buildUI(widget.classdata, list, user, context, "Notes");
          },
        );
        break;
      case "Tests":
        return StreamProvider.value(
          value: widget.classdata.tests,
          builder: (context, child) {
            final list = Provider.of<List<Test>>(context);

            return list == null
                ? Loading()
                : buildUI(widget.classdata, list, user, context, "Tests");
          },
        );
        break;
      default:
        return Text("DIDNT WORK");
    }
  }

  uploadFile() async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child("images/${path.basename(img.path)}");
    StorageUploadTask task = firebaseStorageRef.putFile(img);

    await task.onComplete;

    await firebaseStorageRef.getDownloadURL().then((fileURL) {
      setState(() {
        imageLocation = fileURL;
      });
    });
  }
}
