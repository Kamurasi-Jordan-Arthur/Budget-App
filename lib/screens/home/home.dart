import 'package:grouptour/screens/home/settings/CartegoryEvents.dart';
import 'package:grouptour/screens/home/settings/incomeset.dart';
import 'package:grouptour/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:grouptour/shared/routeconstants.dart';

class Home extends StatefulWidget {
  // final db = Hivestore(); //reference to Class Hivestore

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService(); //reference to fire store
  //reference to Class Hivestore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: TextButton(
          onPressed: () => Navigator.pushNamed(context, cartegoryset),
          child: const Icon(
            Icons.send,
          )),
    );
  }
}
