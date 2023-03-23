import 'package:flutter/material.dart';
import 'package:grouptour/services/store.dart';
import 'package:grouptour/shared/loading.dart';
import 'package:grouptour/shared/routeconstants.dart';

import '../../Utilities/event.dart';

class CartegoryEvents extends StatefulWidget {
  const CartegoryEvents({super.key});

  @override
  State<CartegoryEvents> createState() => _CartegoryEventsState();
}

class _CartegoryEventsState extends State<CartegoryEvents> {
  final db = Hivestore();
  // var resetState = true; // just to reset the screen display.

  Future performLoadAndUpdate() async {
    await db.loadUserData();
    // print(db.incomes);
    // print(db.cartegoryPortion);
    // print(db.incomebox.values);
    //await Future.delayed(const Duration(seconds: 2));
    await db.updateUserData();
    await db.thekeys();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await performLoadAndUpdate();
      setState(() {
        reset = false;
      });
    });
  }

  void _showCategorymenu(
    BuildContext context, {
    String? cartegory,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return CategoryItemBuid(
            cartegory: cartegory,
          );
        });
  }

  bool reset = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      body: (reset)
          ? Loading()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        (db.hivekeys?.length), // TODO REMOVE THE 3 IN THIS LINE
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange)),
                          // T show bottom sheet menu
                          child: Text(
                            db.hivekeys?[index].toUpperCase() ?? "null",
                            style: const TextStyle(color: Colors.black87),
                          ),
                          onPressed: () => _showCategorymenu(
                                context,
                                cartegory: db.hivekeys?[index],
                              ));
                    },
                  ),
                )
              ],
            ),
    );
  }
}
