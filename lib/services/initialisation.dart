import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grouptour/main.dart';
import 'package:flutter/material.dart';

class FireBase extends StatelessWidget {
  FireBase({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(Error);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          //return OurApp();
          return OurApp();
        }
        return const Center(
          widthFactor: 200,
          heightFactor: 200,
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
