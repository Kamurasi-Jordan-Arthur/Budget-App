import 'package:flutter/material.dart';
import 'package:grouptour/services/store.dart';

class Cart_chart_Data {
  final db = Hivestore();
  List<Color> graph_colors = const [
    Color(0xff11bfff),
    Color(0xffff4d94),
    Color(0xFF2DB299),
    Color(0xCE8621B2),
    Color(0xFF13E948),
    Color(0xFFF7FAFA),
  ];

  List<GraphBar> objList = [];
  int longestKey = 0;
  int color_choice = 0;
  String cartegory = "";
  double? maxy;
  double? scale;

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
        // print("null");
        null;
    }
  }

  double getscale() {
    // print(maxy!);
    double swt = maxy! / 10;
    if (swt > 0.05) {
      return 0.1;
    } else if (swt > 0.03) {
      return 0.05;
    } else if (swt > 0.025) {
      return 0.03;
    } else {
      return 0.025;
    }
  }

  double maxY() {
    double largest = 0;
    keyfromstore()?.values.toList().forEach((element) {
      if (element > largest) {
        largest = element;
      }
    });
    return largest;
  }

  Color colorPicker() {
    color_choice++;
    if (color_choice < 5) {
      // print(color_choice);

      return graph_colors[color_choice];
    } else {
      color_choice = 0;

      return graph_colors[color_choice];
    }
  }

  void create_objList() {
    int index = 0;
    keyfromstore()?.forEach((key, value) {
      objList.add(GraphBar(index: index++, key: key, value: value));
    });
  }

  int longest_name() {
    int length = 0;
    keyfromstore()?.forEach((key, value) {
      if (key.length > length) {
        length = key.length;
      }
    });
    return length;
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

class GraphBar {
  String key;
  double value;
  int index;
  GraphBar({required this.index, required this.key, required this.value});
}
