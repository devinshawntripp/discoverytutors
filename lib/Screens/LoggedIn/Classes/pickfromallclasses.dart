import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//current bugs with this widget:
//when choosing a class then unchoosing it it will not update

class PickFromAllClasses extends StatefulWidget {
  // final Function refresh;
  PickFromAllClasses({Key key}) : super(key: key);

  @override
  _PickFromAllClassesState createState() => _PickFromAllClassesState();
}

class _PickFromAllClassesState extends State<PickFromAllClasses> {
  void initState() {
    Provider.of<ClassDataNotifier>(context, listen: false).getTheClasses();
    Provider.of<UserDataNotifier>(context, listen: false).getTheUserClasses();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userdata = context.watch<UserDataNotifier>();
    final user = Provider.of<User>(context);

    List<ClassData> classl = Provider.of<List<ClassData>>(context);
    // print(classl.first.classname);

    return Scaffold(
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
              print(classl);

              List<String> classesPassed = List<String>();
              List<String> classesNotPassed = List<String>();
              for (ClassData n in classl) {
                if (n.picked == true) {
                  classesPassed.add(n.classid);
                } else {
                  classesNotPassed.add(n.classid);
                }
              }

              userdata.addClassesToUser(classesPassed, user.uid);
              userdata.deleteClassesNotPicked(classesNotPassed, user.uid);

              Provider.of<UserDataNotifier>(context, listen: false)
                  .getTheUser(user.uid);
              Provider.of<ClassDataNotifier>(context, listen: false)
                  .getTheUser(user.uid);

              Provider.of<UserDataNotifier>(context, listen: false)
                  .getTheUserClasses();
            },
          ),
        ),
        Expanded(
          child: Container(
            child: classl == null
                ? Loading()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: classl.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Card(
                          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            value: classl[index].picked,
                            onChanged: (value) {
                              setState(() {
                                classl[index].picked = !classl[index].picked;
                              });
                            },
                            title: Text(classl[index].classname),
                            subtitle: Text(classl[index].classid),
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
