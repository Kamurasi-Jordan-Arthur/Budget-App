import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouptour/models/cartegory.dart';
import 'package:grouptour/shared/constants.dart';

class Incomeset extends StatefulWidget {
  const Incomeset({super.key});

  @override
  State<Incomeset> createState() => _IncomesetState();
}

class _IncomesetState extends State<Incomeset> {
  final cart = Cartegory();
  bool refreash = true;
  int sum = 0;
  Future sys() async {
    //sychronise incomes
    await cart.db.loadincomes();
    await cart.db.updateincomes();
    // print(cart.db.incomes?.values.toList());
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await sys();
      sum = cart.incomeSum();
      setState(() {});
    });

    // TODO: implement initState
    super.initState();
  }

  void deleteIncome(index) async {
    //delte the given income
    String? thekey = cart.db.incomes?.keys.toList()[index];
    cart.db.incomes?.remove(thekey);
    await cart.db.updateincomes();
    setState(() {
      refreash = !refreash;
      sum = cart.incomeSum();
    });
  }

  void addNewIncome({required String leading, required int trailing}) async {
    cart.db.incomes![leading] = trailing;
    await cart.db.updateincomes();
    // Navigator.of(context).pop();
    setState(() {
      refreash = !refreash;
      sum = cart.incomeSum();
    });
  }

  void editIncome(int index, String leading, String trailing) async {
    String? thekey = cart.db.incomes?.keys.toList()[index];
    cart.db.incomes?.remove(thekey); //TODO  this is where the data is carptured
    try {
      cart.db.incomes![leading] = int.parse(trailing);
      await cart.db.updateincomes();
    } catch (e) {
      print(e);
    }
    setState(() {
      refreash = !refreash;
      sum = cart.incomeSum();
    });
  }

  // void addNewIncome(String leading, String trailing) {
  //   cart.db.incomes![leading] = int.parse(trailing);
  //   cart.db.updateincomes();
  // }

  void myDialog(
      // BuildContext context,
      {
    required void Function(String, int) onSave,
    required String leadHint,
    required String trailHint,
  }) {
    showDialog(
        context: context,
        builder: ((context) {
          return IncomeEditDialog(
            edit: (p0, p1) => onSave(p0!, p1!),
            leadHint: leadHint,
            trailHint: trailHint,
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    // print(cart.db.incomes?.values.toList());
    // print("object");
    return Scaffold(
      body: Container(
        color: Colors.orange[300],
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.all_inbox_outlined),
              trailing: Container(
                padding: const EdgeInsets.all(4.4),
                color: Colors.redAccent[200],
                child: Text(
                  "${sum} UShs",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[900],
                    letterSpacing: 2.5,
                    fontSize: 15,
                    decorationThickness: 100.8,
                  ),
                ),
              ),
              title: Text(
                "Total ammount".toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  wordSpacing: 2.0,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.4),
                child: ListView.builder(
                  itemCount: (cart.db.incomes == 0 || cart.db.incomes == null)
                      ? 1
                      : cart.db.incomes?.length,
                  itemBuilder: ((context, index) => Incometile(
                      leading: cart.db.incomes?.keys.toList()[index] ??
                          "no incomes set",
                      trailing: cart.db.incomes?.values.toList()[index] ?? 0,
                      delete: () => deleteIncome(index),
                      edit: (leading, trailing) => myDialog(
                            // context,
                            onSave: (leading2, trailing2) {
                              editIncome(index, leading2, trailing2.toString());
                            },
                            leadHint: leading,
                            trailHint: trailing,
                          ))),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => myDialog(
            // context,
            onSave: ((p0, p1) => addNewIncome(leading: p0, trailing: p1)),
            leadHint: "Income Lable",
            trailHint: "Ammount"),
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.add,
          color: Colors.purple,
        ),
      ),
    );
  }
}

class Incometile extends StatelessWidget {
  int trailing;
  String leading;
  VoidCallback delete;
  void Function(String, String) edit;

  Incometile({
    super.key,
    required this.leading,
    required this.trailing,
    required this.delete,
    required this.edit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.5),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.orange,
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                borderRadius: BorderRadius.circular(9),
                onPressed: ((context) => delete()), //TODO delete callback
                icon: Icons.delete,
                backgroundColor: Colors.redAccent,
              ),
            ],
          ),
          startActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(9),
              onPressed: ((val) =>
                  edit(leading, trailing.toString())), // TODO edit callback
              icon: Icons.edit,
              backgroundColor: Colors.lightBlue,
            ),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.2, horizontal: 5.9),
            child: ListTile(
              trailing: Text(
                "$trailing/=",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.brown[900],
                  letterSpacing: 2.5,
                  fontSize: 15,
                  decorationThickness: 100.8,
                ),
              ),
              title: Text(
                leading.toUpperCase(),
                style: TextStyle(
                  wordSpacing: 0.2,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  color: Colors.brown[900],
                  letterSpacing: 2.5,
                  fontSize: 14,
                  decorationThickness: 100.8,
                ),
              ),
              tileColor: Colors.yellow[300],
              style: ListTileStyle.list,
            ),
          ),
        ),
      ),
    );
  }
}
