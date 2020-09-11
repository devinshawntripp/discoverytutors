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
  Widget build(BuildContext context) {
    List<ClassData> classl = Provider.of<List<ClassData>>(context);

    return classl == null
        ? Loading()
        : PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: classl.length,
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (context, index) {
              return Hero(
                tag: widget.data[index],
                child: GestureDetector(
                  onTap: () {
                    classl[index].currentClass = classl[index];
                    widget.dataNotif.currentClass = classl[index].currentClass;

                    Navigator.push(
                        context,
                        MorpheusPageRoute(
                            builder: (context) => ClassPage(
                                  data: classl[index],
                                ),
                            transitionToChild: true));
                  },
                  child: classl == null
                      ? Loading
                      : ClassTile(
                          classname: classl[index].classname,
                          description: classl[index].classdescription,
                          classcode: classl[index].classid,
                        ),
                ),
              );
            });
  }
}
