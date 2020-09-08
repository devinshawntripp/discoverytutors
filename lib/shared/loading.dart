import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff3DDC97),
      child: Center(
        child: SpinKitCircle(
          color: Color(0xffFCFCFC),
          size: 100,
          duration: Duration(milliseconds: 2000),
        ),
      ),
    );
  }
}