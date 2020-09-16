import 'package:disc_t/Screens/RegisterDecider/classtile.dart';
import 'package:disc_t/Screens/RegisterDecider/registerTutor.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassList extends StatefulWidget {
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  @override
  void initState() {
    // Provider.of<ClassDataNotifier>(context, listen: false).getTheClasses();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final d = context.watch<ClassDataNotifier>();
    final classes = Provider.of<List<ClassData>>(context);

    return classes == null
        ? Loading()
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: classes.length,
            itemBuilder: (context, index) {
              return ClassTile(classPassed: classes[index]);
            },
          );
  }
}
