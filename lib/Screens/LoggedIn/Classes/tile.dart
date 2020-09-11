import 'package:disc_t/models/user.dart';
import 'package:flutter/material.dart';
import 'package:morpheus/page_routes/morpheus_page_route.dart';
import 'package:provider/provider.dart';

import 'Homework/homeworklist.dart';

class Tile extends StatefulWidget {
  final String name;
  Tile({Key key, this.name}) : super(key: key);

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  void initState() {
    // Provider.of<ClassDataNotifier>(context, listen: false).getTheHomeworks();
    // Provider.of<ClassDataNotifier>(context, listen: false).getTheNotes();
    // Provider.of<ClassDataNotifier>(context, listen: false).getTheTests();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    // final classDataNotif = context.watch<ClassDataNotifier>();
    return Container(
      child: GestureDetector(
        onTap: () {
          switch (widget.name) {
            case "Homework":
              Navigator.push(
                  context,
                  MorpheusPageRoute(
                    builder: (context) => HomeworkList(
                        // homenotetest: classDataNotif.homework,
                        name: "Homework"),
                    transitionToChild: true,
                  ));
              break;
            case "Notes":
              Navigator.push(
                  context,
                  MorpheusPageRoute(
                    builder: (context) => HomeworkList(
                        // homenotetest: classDataNotif.notes,
                        name: "Notes"),
                    transitionToChild: true,
                  ));
              break;
            case "Tests":
              Navigator.push(
                  context,
                  MorpheusPageRoute(
                    builder: (context) => HomeworkList(
                        // homenotetest: classDataNotif.tests,
                        name: "Tests"),
                    transitionToChild: true,
                  ));
              break;
          }
        },
        child: Container(
          height: h / 10,
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: Row(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.book,
                ),
              ),
              Text(widget.name),
            ],
          ),
        ),
      ),
    );
  }
}
