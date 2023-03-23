import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:grouptour/models/cartegory.dart';
import 'package:grouptour/screens/home/profile/model/user.dart';
import 'package:grouptour/screens/home/profile/page/edit_profile_page.dart';
import 'package:grouptour/screens/home/profile/utils/user_preferences.dart';
import 'package:grouptour/screens/home/profile/widget/appbar_widget.dart';
import 'package:grouptour/screens/home/profile/widget/button_widget.dart';

import 'package:grouptour/screens/home/profile/widget/profile_widget.dart';
import 'package:grouptour/services/store.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final db = Hivestore();
  final user = UserPreferences.getUser();
  void setcurrent_status() async {
    double sum = 0;
    await db.loadCartegoryPortions();
    db.cartegoryPortion?.forEach((key, value) {
      sum += value;
    });
    CurrentStatus = sum;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setcurrent_status();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  static double _lowerValue = 0.0;
  static double _upperValue = 1.0;
  static double CurrentStatus = 0.0;

  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: user.imagePath,
                onClicked: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),
              buildName(user),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      child: SliderBar(),
                    )
                  ],
                ),
              ),
              // Center(child: buildUpgradeButton()),
              //const SizedBox(height: 24),
              //NumbersWidget(),
              const SizedBox(height: 35),
              buildAbout(user),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  // Widget buildUpgradeButton() => ButtonWidget(
  //       text: 'Upgrade To PRO',
  //       onClicked: () {},
  //     );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Me',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  Widget SliderBar() {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 3.0,
        activeTrackColor: Colors.blue,
      ),
      child: Slider(
        //labels: RangeLabels(values.start.toString(), values.end.toString()),
        label: '${CurrentStatus * 100}% Good budgeting!',
        activeColor: Colors.blue[(CurrentStatus * 900).round()],
        inactiveColor: Colors.blue[((1 - CurrentStatus) * 900).round()],
        min: _lowerValue,
        max: _upperValue,

        //value: values,
        value: CurrentStatus,
        // onChanged: (val) {
        //   setState(() {
        //     print(val);
        //     //values = val;
        //     //CurrentStatus = val;
        //   });
        // }
        onChanged: (val) {},
      ),
    );
  }
}
