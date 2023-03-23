import 'package:grouptour/models/user.dart';
import 'package:grouptour/screens/authenticate/authenticate.dart';
import 'package:grouptour/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:grouptour/shared/bottomNav.dart';
import 'package:grouptour/shared/routeconstants.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Ouruser>(context);
    print(user.uid);

    // return either the Home or Authenticate widget
    if (user == null || user.uid == "them") {
      return Authenticate();
    } else {
      return BottomNavBar();
    }
  }
}
