import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//current bugs with this widget:
//when choosing a class then unchoosing it it will not update

class PickFromAllClasses extends StatefulWidget {
  // final Function refresh;
  List<ClassData> classl;
  PickFromAllClasses({Key key, this.classl}) : super(key: key);

  @override
  _PickFromAllClassesState createState() => _PickFromAllClassesState();
}

class _PickFromAllClassesState extends State<PickFromAllClasses> {
  void initState() {
    // Provider.of<ClassDataNotifier>(context, listen: false).getTheClasses();
    // Provider.of<UserDataNotifier>(context, listen: false).getTheUserClasses();

    // final i = Provider.of<UserDataNotifier>(context);
    // final l = Provider.of<ClassDataNotifier>(context);

    // List<String> classesPassed = List<String>();
    // for (ClassData n in i.classes) {
    //   if (n.picked == true) {
    //     int k = 0;

    //     for (ClassData p in l.classes) {
    //       if (n.classid == p.classid) {
    //         l.classes[k].picked = true;
    //       }
    //       k++;
    //     }
    //     // classesPassed.add(n.classid);
    //     // userdata.getTheUserClasses();
    //   }
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final data = context.watch<ClassDataNotifier>();
    // final userdata = context.watch<UserDataNotifier>();
    final user = Provider.of<UserTutor>(context);
    DatabaseService dbs;
    if (user != null) {
      dbs = DatabaseService(uid: user.uid);
    }

    // List<ClassData> classl = Provider.of<List<ClassData>>(context);
    List<ClassData> userClasses =
        widget.classl.where((classdata) => classdata.picked == true).toList();

    return user == null
        ? Loading()
        : widget.classl == null
            ? Loading()
            : userClasses == null
                ? Loading()
                : Scaffold(
                    backgroundColor: Color(0xff3DDC97),
                    appBar: AppBar(
                      leading: GestureDetector(
                        child: Icon(Icons.arrow_back_ios),
                        onTap: () {
                          Navigator.of(context).pop('success');
                        },
                      ),
                      title: Text("Classes"),
                      backgroundColor: Color(0xff46237A),
                    ),
                    body: Column(children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text("Add Classes"),
                          onPressed: () {
                            //get all of the classes that are checked
                            // print(classl);

                            List<String> classesPassed = List<String>();
                            List<String> classesNotPassed = List<String>();
                            for (ClassData n in widget.classl) {
                              if (n.picked == true) {
                                print(n.classid);
                                classesPassed.add(n.classid);
                              } else {
                                classesNotPassed.add(n.classid);
                              }
                            }

                            dbs.addClassesToUser(
                                classesPassed, user.uid, userClasses);
                            dbs.deleteClassesNotPicked(
                                classesNotPassed, user.uid, userClasses);
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: widget.classl == null
                              ? Loading()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.classl.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Card(
                                        margin: EdgeInsets.fromLTRB(
                                            20.0, 6.0, 20.0, 0),
                                        child: CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: widget.classl[index].picked,
                                          onChanged: (value) {
                                            setState(() {
                                              widget.classl[index].picked =
                                                  !widget.classl[index].picked;
                                            });
                                          },
                                          title: Text(
                                              widget.classl[index].classname),
                                          subtitle: Text(
                                              widget.classl[index].classid),
                                        ),
                                      ),
                                    );
                                  }),
                        ),
                      ),
                    ]),
                  );
  }
}
