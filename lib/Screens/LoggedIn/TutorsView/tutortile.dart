import 'package:disc_t/models/tutorModel.dart';
import 'package:flutter/material.dart';
import 'package:disc_t/Screens/LoggedIn/TutorsView/tutor.dart';

class TutorTile extends StatelessWidget {
  final Tutor tutor;
  final Tutor userTutor;

  TutorTile({this.tutor, this.userTutor});

  @override
  Widget build(BuildContext context) {
    String defaultProfPic =
        'https://www.pikpng.com/pngl/m/80-805068_my-profile-icon-blank-profile-picture-circle-clipart.png';

    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Container(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          margin: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 0),
          child: GestureDetector(
            onTap: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TutorClass(tutor: tutor, userTutor: userTutor)));
            }),
            child: GridTile(
                header: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(tutor.profPicURL == ''
                            ? defaultProfPic
                            : tutor.profPicURL),
                        radius: 25,
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        tutor.firstName,
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Text("Rating: ${tutor.rating}"),
                    Text("Votes: ${tutor.totalVotes}"),
                    Text("Contributions: ${tutor.contributions}")
                  ],
                ),
                child: Text("")),
          ),
          // child: ListTile(

          //   onTap: (() {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 TutorClass(tutor: tutor, userTutor: userTutor)));
          //   }),
          //   leading: CircleAvatar(
          //     radius: 25,
          //     backgroundColor: Colors.blue,
          //   ),
          //   title: Text(tutor.firstName),
          //   subtitle: Text("Rating: ${tutor.rating}"),
          // ),
        ),
      ),
    );
  }
}
