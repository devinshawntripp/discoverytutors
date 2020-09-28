import 'package:disc_t/Screens/LoggedIn/ChatView/chat.dart';
import 'package:disc_t/Screens/LoggedIn/ratinglist.dart';
import 'package:disc_t/Screens/LoggedIn/TutorsView/tutorsclasslist.dart';
import 'package:disc_t/Services/database.dart';
import 'package:disc_t/models/chatModel.dart';
import 'package:disc_t/models/messagesModel.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/models/user.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TutorClass extends StatefulWidget {
  final Tutor tutor;
  final Tutor userTutor;
  TutorClass({Key key, this.tutor, this.userTutor}) : super(key: key);

  @override
  _TutorClassState createState() => _TutorClassState();
}

class _TutorClassState extends State<TutorClass> {
  @override
  @override
  void initState() {
    DatabaseService().sumContributions(widget.tutor);
    DatabaseService().sumVotes(widget.tutor);
    super.initState();
  }

  String defaultProfPic =
      'https://www.pikpng.com/pngl/m/80-805068_my-profile-icon-blank-profile-picture-circle-clipart.png';

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    UserTutor user = Provider.of<UserTutor>(context);
    Tutor tutor = Provider.of<Tutor>(context);

    return user == null
        ? Loading()
        : tutor == null
            ? Loading()
            : tutor == null
                ? Loading()
                : StreamProvider<List<ChatModel>>.value(
                    value: tutor.chats,
                    builder: (context, child) {
                      List<ChatModel> userChats =
                          Provider.of<List<ChatModel>>(context);
                      // return Text("lksdjfalsdf");
                      return Scaffold(
                          backgroundColor: Color(0xff3DDC97),
                          appBar: AppBar(
                            backgroundColor: Color(0xff7211E0),
                            // Here we take the value from the MyHomePage object that was created by
                            // the App.build method, and use it to set our appbar title.
                            //create messaging for tutors
                            title: Text(widget.tutor.firstName),
                          ),
                          body: Center(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                SizedBox(
                                  height: 40,
                                ),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      widget.tutor.profPicURL == ''
                                          ? defaultProfPic
                                          : widget.tutor.profPicURL),
                                  backgroundColor: Colors.blue,
                                  radius: 75,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Classes Taken",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ),
                                Expanded(
                                    child: Container(
                                        height: 300,
                                        child: TutorsClassList(
                                            classes: widget.tutor.classes))),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        // SizedBox(height: 20,),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Rating: ",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Color(0xffFCFCFC),
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                                Expanded(
                                                  child: RatingsList(
                                                    tutor: widget.tutor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          // height: MediaQuery.of(context).size.height * 0.10,
                                          child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                                ("RATE P/H: ${widget.tutor.rate}"),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color(0xffFCFCFC),
                                                    fontWeight:
                                                        FontWeight.w800)),
                                          ),
                                        ),
                                        //get each users contributions
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin:
                                              EdgeInsets.fromLTRB(10, 10, 0, 0),
                                          child: Text(
                                              "Contributions: ${widget.tutor.contributions}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xffFCFCFC),
                                                  fontWeight: FontWeight.w800)),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin:
                                              EdgeInsets.fromLTRB(10, 10, 0, 0),
                                          child: Text(
                                              "Votes: ${widget.tutor.totalVotes}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xffFCFCFC),
                                                  fontWeight: FontWeight.w800)),
                                        ),
                                        widget.userTutor.docid ==
                                                widget.tutor.docid
                                            ? Text("")
                                            : Container(
                                                height: h / 14,
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.all(10),
                                                child: RaisedButton(
                                                  color: Colors.blue,
                                                  onPressed: () async {
                                                    //pass in the user using the app as well as the user selected here
                                                    //widget.tutor and the tutor provider
                                                    //since the provider isn't called here and is passed down it will result in an error
                                                    if (widget.userTutor
                                                            .chatWiths ==
                                                        null) {
                                                      //user has no chats currently
                                                      await DatabaseService()
                                                          .createChat(
                                                              widget.tutor,
                                                              widget.userTutor);
                                                    } else {
                                                      if (!tutor.chatWiths
                                                          .contains(widget
                                                              .tutor.docid)) {
                                                        await DatabaseService()
                                                            .createChat(
                                                                widget.tutor,
                                                                widget
                                                                    .userTutor)
                                                            .then((value) {});
                                                      } else {}
                                                    }

                                                    if (userChats != null) {
                                                      ChatModel chat = userChats
                                                          .firstWhere((element) =>
                                                              element.tutorIDS
                                                                  .contains(widget
                                                                      .tutor
                                                                      .docid));

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  StreamProvider<
                                                                      List<
                                                                          Message>>.value(
                                                                    value: chat
                                                                        .messages,
                                                                    child: Chat(
                                                                      chatModel:
                                                                          chat,
                                                                      chatID: chat
                                                                          .chatID,
                                                                      userTutor:
                                                                          tutor,
                                                                    ),
                                                                  )));
                                                    }
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 300,
                                                      child: Text("Chat")),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                )
                              ])));
                    },
                  );
  }
}
