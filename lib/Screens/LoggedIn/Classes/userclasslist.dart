import 'package:disc_t/Screens/LoggedIn/Classes/classTile.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/classpage.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/classpageroute.dart';
import 'package:disc_t/Screens/LoggedIn/Classes/userclasspage.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:provider/provider.dart';

class UserClassList extends StatefulWidget {
  final List<ClassData> data;

  final ClassDataNotifier dataNotif;

  const UserClassList({Key key, this.data, this.dataNotif}) : super(key: key);
  @override
  _UserClassListState createState() => _UserClassListState();
}

class _UserClassListState extends State<UserClassList> {
  @override
  void initState() {
    ClassDataNotifier classdatanotif =
        Provider.of<ClassDataNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    List<ClassData> classl = Provider.of<List<ClassData>>(context);
    var userClassl;

    if (classl != null) {
      print("DLKJFDSLKJFKLDJDKLFJKLSDJ FKLSDJFKLSD JF");
      print(classl.where((element) => (element.picked == true)));
      userClassl = classl.where((element) => (element.picked == true)).toList();
    }

    return classl == null
        ? Loading()
        : PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: userClassl.length,
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (context, index) {
              return Hero(
                tag: classl[index],
                child: GestureDetector(
                  onTap: () {
                    widget.dataNotif.currentClass = widget.data[index];
                    Navigator.push(
                        context,
                        MorpheusPageRoute(
                            builder: (context) =>
                                ClassPage(data: widget.data[index]),
                            transitionToChild: true));
                  },
                  child: ClassTile(
                    classname: userClassl[index].classname,
                    description: userClassl[index].classdescription,
                    classcode: userClassl[index].documentID,
                  ),
                ),
              );
            });
  }
}
