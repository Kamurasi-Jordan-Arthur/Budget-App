import 'dart:async';

import 'package:grouptour/models/cartegory.dart';
import 'package:grouptour/services/store.dart';
import 'package:flutter/material.dart';

class Userplaning {
  Hivestore db = Hivestore();
  String cartegory = "initial"; //TODO deal with initial key word
  Map? userCartPlan;
  Map? newCartData;
  bool canel = false;
  double? cartAmmount;
  int check = 0;

  //TODO set the initial plan
  Userplaning() {
    begintimer();
  }

  begintimer() async {
    // so as to enble one time loading of the data
    print("periodic started");
    // await db.loadcartegorydata(cartegory: cartegory);
    await db.loadUserData();
    // await db.updateUserData();

    Timer.periodic(const Duration(microseconds: 500), (timer) async {
      if (!canel) {
        check = 0;
        newCartData = await db.userbudget.get(cartegory);
        cartAmmount = await db.incomebox.get("cartegoryPortion")[cartegory];
        newCartData!['cartAmmount'] = cartAmmount;

        userCartPlan?.forEach((key, value) {
          if (newCartData![key] == value) {
            check++;
          }
        });
        if (userCartPlan?.length != check) {
          print("$newCartData is commming down the stream");

          userCartPlan = Map.from(newCartData!);
          _controller.sink.add(newCartData);
        }
      } else {
        timer.cancel();
        _controller.close();
      }
    });
  }

  final _controller = StreamController<Map?>();

  Stream<Map?> get stream => _controller.stream;

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

  reloaduserdata({required Map data}) async {
    data.forEach((key, value) {
      keyfromstore()![key] = value;
    });
    // print(keyfromstore()?.remove("cartAmmount"));
    keyfromstore()?.removeWhere((key, value) => key == "cartAmmount");

    await db.updateCartegorydata(cartegory: cartegory);

    // await Future.delayed(Duration(seconds: 1));
    // keyfromstore()?.removeWhere((key, value) => key == "cartAmmount");
    // print(keyfromstore());
  }

  int incomeSum() {
    int sum = 0;
    db.incomes?.values.toList().forEach((element) {
      sum += int.parse(element.toString());
    });
    return sum;
  }
}
