import 'package:flutter/material.dart';
import 'package:grouptour/screens/home/Usergraphs/User%20graps.dart';
import 'package:grouptour/screens/home/profile/page/profile_page.dart';
import 'package:grouptour/screens/home/settings/tadbarview.dart';
import 'package:grouptour/screens/home/user%20planings/userplan.dart';
import 'package:grouptour/services/auth.dart';

// class Profile extends StatelessWidget {
//   const Profile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Icon(
//       Icons.person,
//     );
//   }
// }

class Logic extends StatelessWidget {
  const Logic({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.price_change,
    );
  }
}

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.settings,
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final AuthService _auth = AuthService(); //reference to fire store
  final List<BottomNavigationBarItem> _bottomBarItems = [
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
        ),
        label: "profile"),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.auto_graph,
        ),
        label: "graph"),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.price_change,
        ),
        label: "myplan"),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
        ),
        label: "settings"),
  ];
  final List<Widget> _bodywidget = [
    Profile(),
    const Graph(),
    const MyPlanTabs(),
    const settingTabBar()
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // assert(_bottomBarItems.length == _bodywidget);

    final bottomNavBar = BottomNavigationBar(
      items: _bottomBarItems,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: ((value) => setState(() {
            _currentIndex = value;
          })),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('PBudget'),
        titleSpacing: 0.1,
        titleTextStyle: const TextStyle(
          fontSize: 20.3,
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        elevation: 1.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.person,
                color: Colors.orangeAccent,
              ),
              label: const Text(
                'logout',
                style: TextStyle(color: Colors.yellowAccent),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _bodywidget.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.amber,
        items: _bottomBarItems,
        currentIndex: _currentIndex,
        onTap: ((value) => setState(() {
              _currentIndex = value;
            })),
      ),
    );
  }
}
