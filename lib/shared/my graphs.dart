import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grouptour/models/chart_Data.dart';
import 'package:grouptour/models/pieChartModels.dart';

class CartegoryGraph extends StatefulWidget {
  CartegoryGraph({super.key, required this.cartegory});
  String cartegory;

  @override
  State<CartegoryGraph> createState() => _GraphState();
}

class _GraphState extends State<CartegoryGraph> {
  final db = Cart_chart_Data();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      db.cartegory = widget.cartegory;
      await db.db.loadcartegorydata(cartegory: widget.cartegory);
      db.create_objList();
      db.maxy = db.maxY();
      db.scale = db.getscale();
      db.longestKey = db.longest_name();
      print("refreashed");
      setState(() {});
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    print("body");
    // print(db.keyfromstore());
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 33, 2, 82).withOpacity(1),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      alignment: Alignment.center,
      child: BarChart(BarChartData(
          backgroundColor: const Color(0xff23b6e6).withOpacity(0.3),
          maxY: (db.maxy ?? 0) + (db.scale ?? 0),
          minY: 0,
          groupsSpace: 50,
          gridData: FlGridData(
            show: true,
            // checkToShowHorizontalLine: (value) => value % 0.2 == 0,
            // checkToShowHorizontalLine: (value) =>
            //     (value % (db.scale ?? 0) == 0.0),
            getDrawingHorizontalLine: ((value) {
              return FlLine(
                color: Color.fromRGBO(244, 247, 247, 0.992),
                strokeWidth: .1,
              );
            }),
          ),
          alignment: BarChartAlignment.spaceEvenly,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(
                  axisNameWidget: Text(
                      db.mycategory(hivecartegory: db.cartegory.toString()),
                      style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 5,
                          fontWeight: FontWeight.w400)),
                  sideTitles: SideTitles(reservedSize: 20)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    reservedSize: 35,
                    showTitles: true,
                    getTitlesWidget: ((value, meta) => RotationTransition(
                          turns: const AlwaysStoppedAnimation(30 / 360),
                          child: Text(
                            db.objList
                                .firstWhere(
                                    (element) => element.index == value.toInt())
                                .key,
                            style: TextStyle(color: Colors.amber),
                          ),
                        ))),
              ),
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 25,
                    showTitles: true,
                    // interval: db.scale,
                  ),
                  axisNameWidget: const Text("degree",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        decorationThickness: 3.4,
                      )))),
          barGroups: db.objList
              .map(
                (GraphBar x) => BarChartGroupData(x: x.index, barRods: [
                  BarChartRodData(
                      toY: x.value,
                      width: 16.2,
                      color: db.colorPicker(),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      )),
                ]),
              )
              .toList())),
    );
  }
}

class UserPie extends StatefulWidget {
  const UserPie({super.key, required this.piefor});
  final String piefor;
  @override
  State<UserPie> createState() => _UserPieState();
}

class _UserPieState extends State<UserPie> {
  final PieModel db = PieModel();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      db.piefor = widget.piefor;
      await db.findOperation();
      db.color_choice = 0;
      setState(() {});
    });
    super.initState();
  }

  Future _wait1sec() async {
    Future.delayed(const Duration(seconds: 1));
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 33, 2, 82).withOpacity(1),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: PieChart(PieChartData(
                  // centerSpaceRadius: 5.0,
                  // sectionsSpace: 20,
                  sections: db.myPieData
                          ?.map((key, value) {
                            final sectdata = PieChartSectionData(
                              value: double.parse(value.toString()),
                              color: db.colorPicker(),
                              radius: 20,
                              showTitle: true,
                              titleStyle: const TextStyle(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                              title: (!db.ifincomes!)
                                  ? db.mycategory(hivecartegory: key)
                                  : key,
                            );
                            return MapEntry(key, sectdata);
                          })
                          .values
                          .toList() ??
                      [])),
            ),
            FutureBuilder(
                future: _wait1sec(),
                builder: (context, snapshot) {
                  db.color_choice = 0;
                  print("now at 0");
                  return Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                            widget.piefor.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          )),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: db.myPieData?.length,
                              itemBuilder: (context, index) => Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: db.colorPicker(),
                                    ),
                                    height: 16,
                                    width: 16,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    (!db.ifincomes!)
                                        ? db.mycategory(
                                            hivecartegory: db.myPieData?.keys
                                                    .toList()[index] ??
                                                "loading")
                                        : db.myPieData?.keys.toList()[index] ??
                                            "loading",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ));
                })
          ],
        ));
  }
}
