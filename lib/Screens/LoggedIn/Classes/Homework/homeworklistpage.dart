import 'package:flutter/material.dart';

class HomeworkListPage extends StatefulWidget {
  final dynamic homenotetest;
  final String imageurl;
  HomeworkListPage({Key key, this.homenotetest, this.imageurl})
      : super(key: key);

  @override
  _HomeworkListPageState createState() => _HomeworkListPageState();
}

class _HomeworkListPageState extends State<HomeworkListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff3DDC97),
        appBar: AppBar(
          backgroundColor: Color(0xff7211E0),
          title: Text(widget.homenotetest.filename),
        ),
        body: Container(
            child: Image.network(widget.imageurl,
                loadingBuilder: (context, child, loadingImage) {
          return loadingImage == null
              ? Center(
                  child: child,
                )
              : LinearProgressIndicator(
                  backgroundColor: Colors.white,
                );
        })));
  }
}
