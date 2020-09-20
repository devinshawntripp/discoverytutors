import 'package:disc_t/models/chatModel.dart';
import 'package:disc_t/models/messagesModel.dart';
import 'package:disc_t/models/tutorModel.dart';
import 'package:disc_t/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  String chatID;
  ChatModel chatModel;
  Tutor userTutor;

  Chat({Key key, this.chatID, this.chatModel, this.userTutor})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

Size _textSize(String text, TextStyle style, double width) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: null,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: width / 2);
  return textPainter.size;
}

class _ChatState extends State<Chat> {
  double _inputHeight = 50;
  final TextEditingController _textEditingController = TextEditingController();
  var _scrollController = ScrollController();
  void scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController.addListener(_checkInputHeight);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _checkInputHeight() async {
    int count = _textEditingController.text.split('\n').length;

    if (count == 0 && _inputHeight == 50.0) {
      return;
    }
    if (count <= 5) {
      // use a maximum height of 6 rows
      // height values can be adapted based on the font size
      var newHeight = count == 0 ? 50.0 : 28.0 + (count * 18.0);
      setState(() {
        _inputHeight = newHeight;
      });
    }
  }

  String content = '';
  final TextStyle textStyle = TextStyle(
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    var m = MediaQuery.of(context).size;
    // Tutor userTutor = Provider.of<Tutor>(context);
    List<Message> messageList = Provider.of<List<Message>>(context);

    var heightText = 0.0;

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
                messageList.length == 0
                    ? Text("")
                    : Expanded(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: messageList.length,
                              itemBuilder: (context, index) {
                                // scrollToBottom();
                                heightText = _textSize(
                                            messageList[index].content,
                                            textStyle,
                                            m.width)
                                        .height +
                                    10;
                                return Align(
                                  alignment: messageList[index].idfrom ==
                                          widget.userTutor.docid
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    constraints: BoxConstraints(
                                        minWidth: 100,
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                2),
                                    margin: EdgeInsets.fromLTRB(0, 10, 5, 5),
                                    decoration: BoxDecoration(
                                        color: messageList[index].idfrom ==
                                                widget.userTutor.docid
                                            ? Colors.blue
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    width: _textSize(messageList[index].content,
                                                textStyle, m.width)
                                            .width +
                                        10,
                                    height: _textSize(
                                                messageList[index].content,
                                                textStyle,
                                                m.width)
                                            .height +
                                        10,
                                    child: Center(
                                      child: Text(
                                        messageList[index].content,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                Container(
                  color: Colors.grey,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _textEditingController,
                          textInputAction: TextInputAction.newline,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: "Message",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          onChanged: (val) {
                            setState(() => content = val);
                          },
                        ),
                      ),
                      GestureDetector(
                          child: Icon(Icons.send),
                          onTap: () {
                            scrollToBottom();
                            scrollToBottom();
                            widget.chatModel.sendChat(
                                content, widget.userTutor.docid, "text");
                            setState(() {
                              content = '';
                              _textEditingController.clear();
                              scrollToBottom();
                              // var offset =
                              //     _scrollController.offset + heightText;
                              // _scrollController.jumpTo(offset);
                            });
                          }),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 10,
                  color: Colors.blue,
                )
              ],
            ));
  }
}
