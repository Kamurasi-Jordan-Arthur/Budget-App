import 'package:flutter/material.dart';
import 'package:grouptour/services/store.dart';

class PieModel {
  int color_choice = 0;
  final db = Hivestore();
  List<Color> pie_colors = const [
    Color(0xff11bfff),
    Color(0xffff4d94),
    Color(0xFF2DB299),
    Color(0xCE8621B2),
    Color(0xFF13E948),
    Color(0xFFF7FAFA),
  ];
  String? piefor;
  bool? ifincomes = false;
  Map? myPieData;
  Future findOperation() async {
    if (piefor == "incomes") {
      ifincomes = true;
      await db.loadincomes();
      myPieData = db.incomes;
      return true;
    }
    await db.loadCartegoryPortions();
    myPieData = db.cartegoryPortion;
    return false;
  }

  Color colorPicker() {
    color_choice++;
    if (color_choice == 5) {
      color_choice = 0;
    }
    return pie_colors[color_choice];
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
