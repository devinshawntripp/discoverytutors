import 'package:disc_t/Screens/LoggedIn/Classes/classTile.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/classpage.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/classpageroute.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:provider/provider.dart';

class ClassList extends StatefulWidget {
  final List<ClassData> data;

  final ClassDataNotifier dataNotif;

  const ClassList({Key key, this.data, this.dataNotif}) : super(key: key);
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  @override
  void initState() {
    // ClassDataNotifier classdatanotif =
    //     Provider.of<ClassDataNotifier>(context, listen: false);
    // final user = Provider.of<User>(context);
    // getTheClasses(classdatanotif);
    // List<ClassData> d = classes;
    // List<ClassData> cData = Provider.of<List<ClassData>>(context);
  }

  @override
  Widget build(BuildContext context) {
    // ClassDataNotifier classdatanotif = Provider.of<ClassDataNotifier>(context);

    // final streamClassData = Provider.of<List<ClassData>>(context);

    return PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.data.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          // print("Data from stream list");
          // print(widget.data[index].classdescription);
          return Hero(
            tag: widget.data[index],
            child: GestureDetector(
              onTap: () {
                // print("Data from stream list");
                // print(widget.data[index]);

                widget.dataNotif.currentClass = widget.data[index];
                // print("Tiny willie");

                // print(widget.dataNotif.currentClass.classdescription);

                Navigator.push(
                    context,
                    MorpheusPageRoute(
                        builder: (context) => ClassPage(
                              data: widget.dataNotif.currentClass,
                            ),
                        transitionToChild: true));
              },
              // child: ClassTile(
              //   classname: widget.data[index].classname,
              //   description: widget.data[index].classdescription,
              //   classcode: widget.data[index].documentID,
              // ),
              child: widget.data == null
                  ? Loading
                  : ClassTile(
                      classname: widget.data[index].classname,
                      description: widget.data[index].classdescription,
                      classcode: widget.data[index].classid,
                    ),
            ),
          );
        });
  }
}