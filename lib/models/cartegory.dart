import 'package:flutter/cupertino.dart';
import 'package:grouptour/services/store.dart';

class Cartegory {
  final db = Hivestore();
  bool isOpen = false;
  String? cartegory;
  Widget body() {
    return Text(keyfromstore().toString());
  }

  Cartegory();

  Map? keyfromstore() {
    switch (cartegory) {
      case "needs":
        db.needs?.removeWhere((key, value) => key == "cartAmmount");
        return db.needs;
      case "wants":
        db.wants?.removeWhere((key, value) => key == "cartAmmount");
        return db.wants;
      case "furge":
        db.furge?.removeWhere((key, value) => key == "cartAmmount");
        return db.furge;
      case "thefuture":
        db.thefuture?.removeWhere((key, value) => key == "cartAmmount");
        return db.thefuture;
      default:
        null;
    }
  }

  int incomeSum() {
    int sum = 0;
    db.incomes?.values.toList().forEach((element) {
      sum += int.parse(element.toString());
    });
    return sum;
  }

  String mycategory({required String hivecartegory}) {
    switch (hivecartegory) {
      case "needs":
        return "My needs";
      case "wants":
        return "My Desires / wants";
      case "thefuture":
        return "My Future";
      case "furge":
        return "My uncertainty";
    }
    return "Null";
  }
}
