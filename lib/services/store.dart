import 'package:hive/hive.dart';

// Hive store sevice
class Hivestore {
  //references to the boxes in the hive
  var userbudget = Hive.box("UserBudget");
  var incomebox = Hive.box("UserIncomes");

// maps in UserBudget box
  Map? needs;
  Map? wants;
  Map? thefuture;
  Map? furge;
  List<dynamic>? hivekeys;
  Map? cartegoryPortion;

  //Map in income
  Map? incomes;

  Future thekeys() async {
    hivekeys = await userbudget.keys.toList();
    print("keys have been set");
  }

//put user data to the box
  Future loadUserData() async {
    // print(await userbudget.get("needs").runtimeType);
    needs = await userbudget.get(
          "needs",
        ) ??
        {
          "Subcription": 0.3,
          "Electricity": 0.2,
          "SchoolFees": 0.5,
          "Name": 0.2,
        };

    wants = await userbudget.get(
          "wants",
        ) ??
        {
          "Subcription": 0.3,
          "Electricity": 0.2,
          "SchoolFees": 0.5,
          "Name": 0.2,
        };
    thefuture = await userbudget.get(
          "thefuture",
        ) ??
        {
          "Subcription": 0.3,
          "Electricity": 0.2,
          "SchoolFees": 0.5,
          "Name": 0.2,
        };
    furge = await userbudget.get(
          "furge",
        ) ??
        {
          "Subcription": 0.3,
          "Electricity": 0.2,
          "SchoolFees": 0.5,
          "Name": 0.2,
        };
    incomes = await incomebox.get("incomes") ??
        {
          "Monthly full timming": 780000,
          "Monthly part timming": 160000,
          "Generated pocket  money": 110000,
        };
    cartegoryPortion = await incomebox.get(
          "cartegoryPortion",
        ) ??
        {
          "wants": 0.0,
          "needs": 0.0,
          "thefuture": 0.0,
          "furge": 0.0,
        };
    print("load finised in store");
  }

//upload most of the user data
  Future updateUserData() async {
    await userbudget.put("needs", needs);
    await userbudget.put("wants", wants);
    await userbudget.put("thefuture", thefuture);
    await userbudget.put("furge", furge);
    await incomebox.put("incomes", incomes);
    await incomebox.put("cartegoryPortion", cartegoryPortion);
    print("user data upload finised");
  }

// update only incomes
  Future updateincomes() async {
    await incomebox.put("incomes", incomes);
    print("income update finished");
  }

//load only incomes
  Future loadincomes() async {
    incomes = await incomebox.get("incomes") ??
        {
          "Full timming": 780000,
          "Part timming": 160000,
          "Pocket  money": 110000,
        };
    print("incomes load finised");
  }

// update the cartegory portions
  Future updateCartegorydata({
    // update the cartegory portions
    required String cartegory,
  }) async {
    switch (cartegory) {
      case "wants":
        {
          await userbudget.put("wants", wants);
          return;
        }
      case "needs":
        {
          await userbudget.put("needs", needs);
          print(needs);
          return;
        }
      case "thefuture":
        {
          await userbudget.put("thefuture", thefuture);
          return;
        }
      case "furge":
        {
          await userbudget.put("furge", furge);
          return;
        }
    }
  }

  Future loadcartegorydata({
    // update the cartegory portions
    required String cartegory,
  }) async {
    switch (cartegory) {
      case "wants":
        {
          wants = await userbudget.get(
                "wants",
              ) ??
              {
                "Subcription": 0.3,
                "Electricity": 0.2,
                "SchoolFees": 0.5,
                "Name": 0.2,
              };
          return;
        }
      case "needs":
        {
          needs = await userbudget.get(
                "needs",
              ) ??
              {
                "Subcription": 0.3,
                "Electricity": 0.2,
                "SchoolFees": 0.5,
                "Name": 0.2,
              };

          return;
        }
      case "thefuture":
        {
          thefuture = await userbudget.get(
                "thefuture",
              ) ??
              {
                "Subcription": 0.3,
                "Electricity": 0.2,
                "SchoolFees": 0.5,
                "Name": 0.2,
              };
          return;
        }
      case "furge":
        {
          furge = await userbudget.get(
                "furge",
              ) ??
              {
                "Subcription": 0.3,
                "Electricity": 0.2,
                "SchoolFees": 0.5,
                "Name": 0.2,
              };
          return;
        }
    }
  }

  Future loadCartegoryPortions() async {
    cartegoryPortion = await incomebox.get(
          "cartegoryPortion",
        ) ??
        {
          "wants": 0.0,
          "needs": 0.0,
          "thefuture": 0.0,
          "furge": 0.0,
        };
  }

  Future updateCartPortion() async {
    incomebox.put("cartegoryPortion", cartegoryPortion);
  }

  // prepareNewPlanData({String? forcartegory}) {
  //   new await userbudget.get(forcartegory);
  // }
}
