import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouptour/models/cartegory.dart';
import 'package:grouptour/shared/constants.dart';
import 'package:grouptour/shared/loading.dart';

class CategoryItemBuid extends StatefulWidget {
  String? cartegory;
  CategoryItemBuid({super.key, this.cartegory});

  @override
  State<CategoryItemBuid> createState() => _CategoryItemBuidState();
}

class _CategoryItemBuidState extends State<CategoryItemBuid> {
  final cart = Cartegory();
  bool reset = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      cart.cartegory = widget.cartegory;
      await cart.db.loadUserData();
      setState(() {
        reset = false;
      });
    });
    super.initState();
  }

//add new feild to needs map
  void showMyAddDialogbox(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: ((context) {
          return DialogBox(
            buttontext: "add",
            currentName: "add another",
            onPress: (val) async {
              await cart.db.loadUserData();
              cart.keyfromstore()![val] = 0.0;
              await cart.db.updateUserData();
              Navigator.pop(context);
            },
          );
        }));
  }

//get formated cartegory title
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

  int count = 0;
  @override
  Widget build(BuildContext context) {
    return (reset)
        ? Loading()
        : Container(
            color: Colors.amber[100],
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    mycategory(hivecartegory: widget.cartegory!),
                    style: TextStyle(
                        // backgroundColor: Colors.red,
                        color: Colors.green[798],
                        fontStyle: FontStyle.italic,
                        fontSize: 22.0),
                  ),
                )),
                Expanded(
                  child: ListView.builder(
                      itemCount: cart.keyfromstore()?.length ??
                          2, //TODO REMOVE THE 2IN THIS LINE
                      itemBuilder: (context, index) {
                        return Event(
                          callback: (() => setState(() {
                                count++;
                                print(count);
                              })),
                          theEvent: cart.keyfromstore()?.keys.toList()[index],
                          index: index,
                          cartegory: widget.cartegory,
                        );
                      }),
                ),
                ElevatedButton.icon(
                  label: Text(
                    "ADD TO ${cart.mycategory(hivecartegory: cart.cartegory!)}",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      letterSpacing: 2.0,
                    ),
                  ),
                  onPressed: () => showMyAddDialogbox(context),
                  icon: const Icon(
                    Icons.add,
                  ),
                )
              ],
            ),
          );
  }
}

class Event extends StatefulWidget {
  String? theEvent;
  int? index;
  String? cartegory;
  VoidCallback callback;
  // VoidCallback parentCallReset;
  Event({
    super.key,
    required this.theEvent,
    required this.index,
    required this.cartegory,
    required this.callback,
    // required this.parentCallReset,
  });

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  final cart = Cartegory();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await cart.db.loadUserData();
      cart.cartegory = widget.cartegory;
      print('event init');
    });

    super.initState();
  }

  bool resetState = true;

  void modifyEventTitle(String newtitle, int index) async {
    // await cart.db.loadUserData();
    // print(cart.keyfromstore());
    print(cart.keyfromstore()); //TODO check for keys
    String? thekey = cart.keyfromstore()!.keys.toList()[index];
    double? thevalue = cart.keyfromstore()![thekey];
    cart.keyfromstore()!.remove(thekey);
    cart.keyfromstore()![newtitle] = thevalue;
    cart.db.updateUserData();

    //TODO implement the change of the title of the that index
  }

  //add new feild to needs map
  void showMyChangeDialogbox(BuildContext context, {int? index}) {
    showDialog(
        context: context,
        builder: ((context) {
          return DialogBox(
              buttontext: "Save $index",
              currentName: cart.keyfromstore()?.keys.toList()[index!],
              onPress: (
                newtitle,
              ) {
                modifyEventTitle(newtitle!, index!);
                Navigator.pop(context);
              });
        }));
  }

  void deleteEvent(int index) async {
    String thekey = cart.keyfromstore()?.keys.toList()[index];
    cart.keyfromstore()?.remove(thekey);
    await cart.db.updateUserData();
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    cart.db.loadUserData;
    print("at event build");
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(9),
            onPressed: (context) => deleteEvent(widget.index!),
            icon: Icons.delete,
            backgroundColor: Colors.redAccent,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.2, horizontal: 5.9),
        child: ListTile(
          trailing: const Icon(
            Icons.edit,
            color: Colors.black45,
          ),
          onLongPress: () {
            showMyChangeDialogbox(context, index: widget.index);
          },
          hoverColor: Colors.yellowAccent,
          title: Text(
            widget.theEvent ?? "home",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.brown[900],
              letterSpacing: 2.5,
              fontSize: 15,
              decorationThickness: 100.8,
            ),
          ),
          tileColor: Colors.amber[30],
          style: ListTileStyle.list,
        ),
      ),
    );
  }
}
