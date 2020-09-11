import 'package:disc_t/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final data = context.watch<ClassDataNotifier>();
    final userdata = context.watch<UserDataNotifier>();
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Color(0xff3DDC97),
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios),
          onTap: () {
            // widget.refresh();
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

              List<String> classesPassed = List<String>();
              for (ClassData n in data.classes) {
                if (n.picked == true) {
                  classesPassed.add(n.classid);
                  // userdata.getTheUserClasses();
                }
              }

              userdata.addClassesToUser(classesPassed, user.uid);
            },
          ),
        ),
        Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.classes.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  child: Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: data.classes[index].picked,
                      onChanged: (value) {
                        setState(() {
                          data.classes[index].picked =
                              !data.classes[index].picked;
                        });
                      },
                      title: Text(data.classes[index].classname),
                      subtitle: Text(data.classes[index].classid),
                    ),
                  ),
                );
              }),
        ),
      ]),
    );
  }
}
