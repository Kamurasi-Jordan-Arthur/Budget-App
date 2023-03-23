import 'package:flutter/material.dart';
import 'package:grouptour/models/userplanning.dart';
import 'package:grouptour/screens/Utilities/event.dart';
import 'package:grouptour/shared/constants.dart';
import 'package:grouptour/shared/loading.dart';

class SingleFieldTextform extends StatefulWidget {
  const SingleFieldTextform({super.key});

  @override
  State<SingleFieldTextform> createState() => _SingleFieldTextformState();
}

class _SingleFieldTextformState extends State<SingleFieldTextform> {
  final _textcontroller = TextEditingController();
  String? usertext;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            controller: _textcontroller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Change The Name',
              suffixIcon: IconButton(
                  onPressed: () {
                    //clear the text on the users text field
                    setState(() {
                      _textcontroller.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.clear,
                  )),
            ),
          ),
          MaterialButton(
              child: const Text(
                "Change",
                selectionColor: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  usertext = _textcontroller.text;
                });
                print(usertext);
                // Navigator.pop(
                //   context,
                // );
              })
        ],
      ),
    );
  }
}

class Plancard extends StatefulWidget {
  Plancard({
    super.key,
    required this.leadingTitle,
    required this.cartAmmout,
    required this.eventPortion,
    required this.onChangeEnd,
  });
  String leadingTitle;
  double cartAmmout;
  double eventPortion;
  Function(double) onChangeEnd;

  @override
  State<Plancard> createState() => _PlancardState();
}

class _PlancardState extends State<Plancard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      color: Colors.deepOrange,
      padding: const EdgeInsets.all(4.8),
      child: Column(
        children: [
          SizedBox(
            child: ListTile(
              leading: Text(widget.leadingTitle),
              trailing: Text(
                  "${((widget.cartAmmout) * (widget.eventPortion)).toStringAsFixed(1)}Shs"),
            ),
          ),
          Slider(
            value: widget.eventPortion,
            onChanged: ((value) => setState(() {
                  widget.eventPortion = value;
                })),
            onChangeEnd: ((value) => widget.onChangeEnd(value)),
            activeColor:
                Colors.blue[((widget.eventPortion ~/ 1) * 900).truncate()],
            inactiveColor: Colors
                .blue[((1 - (widget.eventPortion ~/ 1)) * 900).truncate()],
            min: 0,
            max: 1,
            divisions: 1000,
            label: "${widget.eventPortion * 100}%",
          ),
        ],
      ),
    );
  }
}

class ExpasionBody extends StatefulWidget {
  ExpasionBody({super.key, required this.cartegory});
  String cartegory;

  @override
  State<ExpasionBody> createState() => _ExpasionBodyState();
}

class _ExpasionBodyState extends State<ExpasionBody> {
  bool restart = true;
  Userplaning db = Userplaning();
  Map? planCardDetaiL;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      db.cartegory = widget.cartegory;
      Future.delayed(const Duration(seconds: 2));
      setState(() {
        restart = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    db.canel = true;
    // TODO: implement dispose
    super.dispose();
  }

  void onChangeEnd({required int index, required double value}) {
    Map workWithMap = Map.from(planCardDetaiL!); //remove the amount fromthe map
    workWithMap.remove("cartAmmount");
    String thekey = workWithMap.keys.toList()[index];
    workWithMap[thekey] = value;
    double sum = 0.0;
    workWithMap.forEach((key, value) {
      sum += value;
    });
    // print("changend");
    if (sum > 1) {
      value = double.parse((value - (sum - 1)).toStringAsFixed(7));
      // value = double.parse(value.toString().substring(0, 4));
      // String thekey = workWithMap.keys.toList()[index];
      workWithMap[thekey] = value;
      db.reloaduserdata(data: workWithMap);
      //raise alert dialog
      showDialog(
          context: context,
          builder: (context) => Alertdialog(
              message:
                  "You are currently using more than 100% of your allocation in ${db.cartegory}"));
      // Future.delayed(const Duration(seconds: 1));
      // setState(() {});
    } else {
      db.reloaduserdata(data: workWithMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("${db.cartegory} at expasionbody widget build");
    return (restart)
        ? Loading()
        : StreamBuilder<Map?>(
            stream: db.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState != ConnectionState.waiting) {
                if (snapshot.data?.length != 1) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await Future.delayed(const Duration(seconds: 1));
                    if (mounted) {
                      planCardDetaiL = snapshot.data;
                      // print(snapshot.data);
                      // setState(() {
                      //   planCardDetaiL = Map.from(snapshot.data!);
                      // });
                    }
                  });
                }
              }
              return Container(
                height: 250,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (planCardDetaiL == null)
                        ? 0
                        : (planCardDetaiL?.length)! - 1,
                    itemBuilder: ((context, index) {
                      return Plancard(
                        leadingTitle: planCardDetaiL?.keys.toList()[index],
                        cartAmmout:
                            (planCardDetaiL!["cartAmmount"] * db.incomeSum()),
                        eventPortion: planCardDetaiL?.values.toList()[index],
                        onChangeEnd: ((p0) =>
                            onChangeEnd(index: index, value: p0)),
                      );
                    })),
              );
            });
  }
}
