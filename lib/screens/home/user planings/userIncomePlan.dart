import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grouptour/services/store.dart';
import 'package:grouptour/shared/constants.dart';
import 'package:grouptour/shared/loading.dart';

class UserIncomePlan extends StatefulWidget {
  const UserIncomePlan({super.key});

  @override
  State<UserIncomePlan> createState() => _UserIncomePlanState();
}

class _UserIncomePlanState extends State<UserIncomePlan> {
  Hivestore store = Hivestore();
  // Map? cartPot;
  bool refreash = true;
  double availableIn = 0;
  double factor = 0.00;
  bool restart = true;
  final updateIcomeCard = StreamController<bool>();

  double remIncome() {
    double cartpot = 0;
    store.cartegoryPortion?.values.toList().forEach((element) {
      cartpot += element;
    }); //sum of the available portions givenout.
    if (cartpot == 0) {
      return (incomeSum().toDouble());
    } else {
      return (incomeSum().toDouble() * (1 - cartpot));
    }
  }

  int incomeSum() {
    // total of the incomes
    int sum = 0;
    store.incomes?.values.toList().forEach((element) {
      sum += int.parse(element.toString());
    });
    return sum;
  }

  Future loadIncomeCartPortion() async {
    store.loadincomes();
    store.loadCartegoryPortions();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadIncomeCartPortion();
      availableIn = remIncome();

      setState(() {
        restart = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    store.updateCartPortion();
    updateIcomeCard.close();
    // TODO: implement dispose
    super.dispose();
  }

  double cartsum() {
    double sum = 0;
    store.cartegoryPortion?.values.toList().forEach((element) {
      sum += element;
    });
    return sum;
  }

  void add_deduct(int index, {required bool add}) {
    String thekey = store.cartegoryPortion?.keys.toList()[index];

    if (add) {
      if ((1 - cartsum()) > factor) {
        double addvalue = store.cartegoryPortion![thekey] + factor;
        store.cartegoryPortion![thekey] = addvalue;
        setState(() {
          refreash = !refreash;
          updateIcomeCard.sink.add(true);
        });
        return;
      }
    } else {
      if (store.cartegoryPortion?[thekey] > factor) {
        double subvalue = store.cartegoryPortion![thekey] - factor;
        store.cartegoryPortion![thekey] = subvalue;
        setState(() {
          refreash = !refreash;
          updateIcomeCard.sink.add(true);
        });
        return;
      } else {
        store.cartegoryPortion![thekey] = 0.0;
      }
    }
    setState(() {
      refreash = !refreash;
      updateIcomeCard.sink.add(true);
    });
    showDialog(
        context: context,
        builder: (context) => Alertdialog(
            message: (add)
                ? "There is less income to carry out that operation./n consider deallocation from other cartegories or slidding down the ADD/DEDUCT slider below"
                : "There is less income allocated to $thekey for deduction to take place, consider slidding down the ADD/DEDUCT slider below"));
  }

  @override
  Widget build(BuildContext context) {
    return (restart)
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.orange[300],
            body: Column(children: [
              StreamBuilder<bool>(
                  stream: updateIcomeCard.stream,
                  builder: (context, snapshot) {
                    // if (snapshot.hasData) {
                    availableIn = remIncome();
                    return IncomeCard(
                        availableIn: "${availableIn.round().toString()} /=",
                        totalincome: "${incomeSum().toString()} UShs,");
                    // }
                  }),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: ListView.builder(
                    itemCount: store.cartegoryPortion?.length,
                    itemBuilder: (context, index) => CartTile(
                        cartegory: store.cartegoryPortion?.keys.toList()[index],
                        ammount: (incomeSum() *
                                store.cartegoryPortion?.values.toList()[index])
                            .toInt(),
                        add: () => add_deduct(index, add: true),
                        deduct: () => add_deduct(index, add: false))),
              )),
              Slider(
                label:
                    "Add by ${(factor * 100).toStringAsFixed(2)}% of total Income",
                value: factor,
                onChanged: (value) => setState(() {
                  factor = value;
                }),
                divisions: 10000,
                max: .1,
                min: 0.0,
                activeColor: Colors.purple[(factor * 900).toInt()],
                inactiveColor: Colors.purple[((1 - factor) * 900).toInt()],
              )
            ]),
          );
  }
}

class IncomeCard extends StatelessWidget {
  IncomeCard({
    super.key,
    required this.totalincome,
    required this.availableIn,
  });
  String totalincome;
  String availableIn;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.redAccent,
      color: Colors.amber,
      margin: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 8.0,
      ),
      elevation: 10,
      // shadowColor: Colors.red[(int.parse(availableIn.split(" Ugshs")[0]) /
      //         int.parse(totalincome.split(" Ugshs")[0]) *
      //         900)
      //     .toInt()],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // textDirection: TextDirection.ltr,
          children: [
            Headtext(headtext: "Available money"),
            BodyText(bodytext: availableIn),
            const SizedBox(
              height: 6,
            ),
            Headtext(headtext: "Total Income"),
            BodyText(bodytext: totalincome)
          ],
        ),
      ),
    );
  }
}

class Headtext extends StatelessWidget {
  Headtext({super.key, required this.headtext});
  final headtext;
  @override
  Widget build(BuildContext context) {
    return Text(
      headtext,
      style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
          color: Theme.of(context).primaryColorDark),
    );
  }
}

class BodyText extends StatelessWidget {
  BodyText({super.key, required this.bodytext});
  final bodytext;
  @override
  Widget build(BuildContext context) {
    return Text(
      bodytext,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24.0,
          color: Theme.of(context).primaryColorDark),
    );
  }
}

class CartTile extends StatelessWidget {
  CartTile({
    super.key,
    required this.cartegory,
    required this.ammount,
    required this.add,
    required this.deduct,
  });
  String cartegory;
  int ammount;
  VoidCallback add;
  VoidCallback deduct;

  // String title(String cartegory) {
  //   switch (cartegory) {
  //     case "needs":
  //       return "My Needs";
  //     case "wants":
  //       return "My Wants";
  //     case "furge":
  //       return "My Furge";
  //     case "thefuture":
  //       return "My Future";
  //     default:
  //       return "null";
  //   }
  // }
  String title(String cartegory) {
    switch (cartegory) {
      case "needs":
        return "My needs";
      case "wants":
        return "MyDesires/wants";
      case "thefuture":
        return "My Future";
      case "furge":
        return "My uncertainty";
    }
    return "Null";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(7),
          ),
          color: Colors.orange,
        ),
        child: ListTile(
          // contentPadding: EdgeInsets.symmetric(vertical: 2.1, horizontal: 2),
          visualDensity: VisualDensity.compact,
          leading: Text(
            title(cartegory),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15.2,
              color: Colors.grey,
              decorationThickness: 75,
            ),
          ),
          trailing: ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  style: const ButtonStyle(
                      elevation: MaterialStatePropertyAll(8.0)),
                  onPressed: deduct,
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  )),
              // const SizedBox(
              //   width: 2,
              // ),
              IconButton(
                  style: const ButtonStyle(
                      elevation: MaterialStatePropertyAll(8.0)),
                  onPressed: add,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black87,
                  )),
            ],
          ),
          title: Text(
            "${ammount.toString().toUpperCase()} /=",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
              // letterSpacing: 2.5,
              fontSize: 18,
              // decorationThickness: 100.8,
            ),
          ),
        ),
      ),
    );
  }
}
