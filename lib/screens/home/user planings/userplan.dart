import "package:flutter/material.dart";
import 'package:grouptour/models/cartegory.dart';
import 'package:grouptour/screens/Utilities/forms.dart';
import 'package:grouptour/services/store.dart';
import 'package:grouptour/shared/loading.dart';

class Userplan extends StatefulWidget {
  Userplan({super.key});

  @override
  State<Userplan> createState() => _UserplanState();
}

class _UserplanState extends State<Userplan> {
  final db = Hivestore();
  List<Cartegory> expansionlist = []; //list of thediferent categories
  int sum = 0;

  Future loadEpansionList() async {
    await db.loadUserData();
    await db.updateUserData();
    await db.thekeys();
    db.hivekeys?.forEach((element) async {
      var cart = Cartegory();
      cart.cartegory = element.toString();
      // await cart.db.loadcartegorydata(cartegory: element);
      // await cart.db.loadincomes();
      await cart.db.loadUserData();
      // await cart.db.updateCartegorydata(cartegory: element);
      // await cart.db.updateUserData();
      expansionlist.add(cart);
    });
  }

  bool loading = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadEpansionList();
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.orange[200],
            body: ListView(
              children: [
                ExpansionPanelList(
                  children: expansionlist
                      .map((Cartegory e) => ExpansionPanel(
                            backgroundColor: Colors.orange[500],
                            headerBuilder: ((context, isExpanded) => Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        e.cartegory.toString().toUpperCase(),
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 3.2),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 7),
                                        color: Colors.red[500],
                                        child: Text(
                                            "${(e.db.cartegoryPortion![e.cartegory] * e.incomeSum()).truncate()}/="),
                                      ),
                                    ],
                                  ),
                                )),
                            body: ExpasionBody(
                                cartegory: e.cartegory!), //e.body(),

                            isExpanded: e.isOpen,
                          ))
                      .toList(),
                  expansionCallback: (panelIndex, isExpanded) {
                    if (!isExpanded) {
                      setState(() {
                        for (var element in expansionlist) {
                          //first close all the rest
                          element.isOpen = false;
                        }
                        expansionlist[panelIndex].isOpen =
                            !isExpanded; //then open that instance
                      });
                    } else {
                      setState(() {
                        expansionlist[panelIndex].isOpen = !isExpanded;
                      }); //else just open it
                    }
                  },
                ),
              ],
            ),
          );
  }
}
