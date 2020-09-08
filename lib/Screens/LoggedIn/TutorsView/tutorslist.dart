import 'package:disc_t/Screens/LoggedIn/TutorsView/tutortile.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorsList extends StatefulWidget {
  @override
  _TutorsListState createState() => _TutorsListState();
}

class _TutorsListState extends State<TutorsList> {
  @override
  Widget build(BuildContext context) {
    final tutors = Provider.of<List<Tutor>>(context);
    //print("some instance of a user");
    //print(tutors[0].classes);
    // print(tutors.documents);

    // tutors.forEach((tutor) {
    //   print(tutor.firstName);
    //   print(tutor.rating);
    // });

    return tutors == null
        ? Loading()
        : ListView.builder(
            itemCount: tutors.length,
            itemBuilder: (context, index) {
              return TutorTile(tutor: tutors[index]);
            },
          );
  }
}
