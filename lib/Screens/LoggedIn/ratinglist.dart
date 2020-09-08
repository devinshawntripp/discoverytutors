import 'package:disc_t/Screens/LoggedIn/startile.dart';
import 'package:disc_t/models/user.dart';
import 'package:flutter/material.dart';

class RatingsList extends StatefulWidget {
  final Tutor tutor;
  RatingsList({this.tutor});
  @override
  _RatingsListState createState() => _RatingsListState();
}

class _RatingsListState extends State<RatingsList> {
  @override
  Widget build(BuildContext context) {
    // print("some instance of a user");
    // print(tutors[0].classes);

    return Container(
      width: 200,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return StarTile(tutor: widget.tutor);
        },
      ),
    );
  }
}
