import 'package:disc_t/Screens/LoggedIn/Classes/userclasspage.dart';
import 'package:disc_t/models/user.dart';
import 'package:flutter/material.dart';

import 'classpage.dart';

class ClassPageRoute extends MaterialPageRoute {
  ClassPageRoute(UserClassData data)
      : super(builder: (context) => UserClassPage(data: data));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
