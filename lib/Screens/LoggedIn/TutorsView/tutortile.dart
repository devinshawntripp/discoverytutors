import 'package:disc_t/models/tutorModel.dart';
import 'package:flutter/material.dart';
import 'package:disc_t/Screens/LoggedIn/TutorsView/tutor.dart';

class TutorTile extends StatelessWidget {
  final Tutor tutor;
  final Tutor userTutor;

  TutorTile({this.tutor, this.userTutor});

  @override
  Widget build(BuildContext context) {
    // print("some bullshit");
    // print(tutor.classes);

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
                            ? 'https://lh3.googleusercontent.com/proxy/Bqm0w3JLMVxKcj15Zx3ZiC9l0ZK7GhZux3ihhwhdT-H8O7uO_SCQzkZBNJ9oTw2MMdVUvXCLuRUZjl9XSTqFj-t5cctQDaNaM65edDWeSVKRbYxomIAy9l_zU1AgzBuCx93pWHCGmZZ8Comc49haptCrikiaRFO4-QIfLotYAyTQ'
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
                    Text("Rating: ${tutor.totalVotes}"),
                    Text("Rating: ${tutor.contributions}")
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
