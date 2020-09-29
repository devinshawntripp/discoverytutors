import 'package:animations/animations.dart';
import 'package:disc_t/Screens/LoggedIn/TutorsView/tutor.dart';
import 'package:disc_t/Screens/LoggedIn/TutorsView/tutortile.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorsList extends StatefulWidget {
  final Tutor userTutor;
  TutorsList({Key key, this.userTutor}) : super(key: key);

  @override
  _TutorsListState createState() => _TutorsListState();
}

class _TutorsListState extends State<TutorsList> {
  @override
  Widget build(BuildContext context) {
    final tutors = Provider.of<List<Tutor>>(context);

    return tutors == null
        ? Loading()
        : GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            padding: EdgeInsets.all(5),
            children: List.generate(tutors.length, (index) {
              return OpenContainer(
                closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                closedColor: Colors.green,
                closedElevation: 0,
                openBuilder: (context, closedAction) {
                  return TutorClass(
                      tutor: tutors[index], userTutor: widget.userTutor);
                },
                closedBuilder: (context, openAction) {
                  return TutorTile(
                    tutor: tutors[index],
                    userTutor: widget.userTutor,
                    openAction: openAction,
                  );
                },
              );
            }),
          );
  }
}
