import 'package:disc_t/models/chatModel.dart';
import 'package:disc_t/models/messagesModel.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  String chatID;
  ChatModel chatModel;

  Chat({Key key, this.chatID, this.chatModel}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

Size _textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

class _ChatState extends State<Chat> {
  String content = '';
  final TextStyle textStyle = TextStyle(
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    Tutor userTutor = Provider.of<Tutor>(context);
    return StreamProvider<List<Message>>.value(
      value: widget.chatModel.messages,
      child: Consumer<List<Message>>(
        builder: (context, messageList, child) {
          return messageList == null
              ? Loading()
              : Scaffold(
                  backgroundColor: Color(0xff3DDC97),
                  appBar: AppBar(
                    backgroundColor: Color(0xff7211E0),
                    // Here we take the value from the MyHomePage object that was created by
                    // the App.build method, and use it to set our appbar title.
                    //create messaging for tutors
                    title: Text(widget.chatID),
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      for (var n in messageList)
                        Align(
                          alignment: n.idfrom == userTutor.docid
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 5, 5),

                            // color: Colors.blue,
                            decoration: BoxDecoration(
                                color: n.idfrom == userTutor.docid
                                    ? Colors.blue
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(20)),
                            // width: MediaQuery.of(context).size.width / 2,
                            width: _textSize(n.content, textStyle).width + 10,

                            height: _textSize(n.content, textStyle).height + 10,
                            child: Center(
                              child: Text(
                                n.content,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            // color: Colors.blue,
                          ),
                        ),
                      // Container(
                      //     color: Colors.grey,
                      //     child: TextFormField(
                      //       decoration: InputDecoration(hintText: "Message"),
                      //     )),
                      Container(
                        color: Colors.grey,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(hintText: "Message"),
                                onChanged: (val) {
                                  setState(() => content = val);
                                },
                              ),
                            ),
                            GestureDetector(
                                child: Icon(Icons.send),
                                onTap: () {
                                  widget.chatModel.sendChat(
                                      content, userTutor.docid, "text");
                                }),
                          ],
                        ),
                      )
                    ],
                  )
                  // body: Column(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: <Widget>[
                  //     Row(
                  //       children: <Widget>[
                  //         Container(
                  //           color: Colors.grey,
                  //           child: TextFormField(
                  //             decoration: InputDecoration(
                  //                 hintText: "type your message"),
                  //           ),
                  //         ),
                  //         // Icon(Icons.send)
                  //       ],
                  //     )
                  //   ],
                  // ),
                  );
        },
      ),
    );
  }
}
