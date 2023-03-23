import 'package:flutter/material.dart';
import 'package:grouptour/screens/home/settings/CartegoryEvents.dart';
import 'package:grouptour/screens/home/settings/incomeset.dart';
import 'package:grouptour/screens/home/user%20planings/userIncomePlan.dart';
import 'package:grouptour/screens/home/user%20planings/userplan.dart';
import 'package:grouptour/shared/appbars.dart';
import 'package:grouptour/shared/routeconstants.dart';

class settingTabBar extends StatelessWidget {
  const settingTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(children: const [
            TabBar(
              labelColor: Colors.blueGrey,
              labelStyle: TextStyle(decorationColor: Colors.black87),
              // indicatorColor: Colors.amber,
              tabs: [
                incomeTabBar,
                cartegoryTabBar,
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                Incomeset(),
                CartegoryEvents(),
              ]),
            )
          ]),
        ));
  }
}

class MyPlanTabs extends StatelessWidget {
  const MyPlanTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [incomePlane, cartegorywisePlan],
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(children: [
              const UserIncomePlan(),
              Userplan(),
            ]),
          )
        ],
      ),
    );
  }
}
