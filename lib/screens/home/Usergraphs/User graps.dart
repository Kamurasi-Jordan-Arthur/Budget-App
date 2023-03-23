import 'package:flutter/material.dart';
import 'package:grouptour/shared/my graphs.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

List<Widget> usergraphs = [
  const UserPie(piefor: "incomes"),
  const UserPie(piefor: "cartegoryportions"),
  CartegoryGraph(cartegory: "needs"),
  CartegoryGraph(cartegory: "wants"),
  CartegoryGraph(cartegory: "thefuture"),
  CartegoryGraph(cartegory: "furge"),
];

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.orange[200],
        child: DefaultTabController(
          length: usergraphs.length,
          child: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                const TabPageSelector(),
                Expanded(child: TabBarView(children: usergraphs)),
                ElevatedButton(
                  onPressed: () {
                    final TabController controller =
                        DefaultTabController.of(context)!;
                    if (!controller.indexIsChanging) {
                      controller.animateTo(2);
                    }
                  },
                  child: const Text(
                    "Skip to Barchart",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w700,
                      decorationThickness: 3.4,
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
