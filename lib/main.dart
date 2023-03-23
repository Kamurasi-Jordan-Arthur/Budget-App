import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouptour/screens/home/profile/themes.dart';
import 'package:grouptour/screens/home/profile/utils/user_preferences.dart';
import 'package:grouptour/screens/home/settings/CartegoryEvents.dart';
import 'package:grouptour/screens/wrapper.dart';
import 'package:grouptour/services/Routegenetrator.dart';
import 'package:grouptour/services/auth.dart';
import 'package:grouptour/models/user.dart';
import 'package:grouptour/services/initialisation.dart';
import 'package:grouptour/shared/routeconstants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await UserPreferences.init();
  await Hive.initFlutter();
  await Hive.openBox("UserBudget");
  // await Hive.box("userbudget").clear();
  await Hive.openBox("UserIncomes");
  //open required boxes

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'User Profile';
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();
    return ThemeProvider(
      initTheme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
      child: Builder(builder: (context) {
        return MaterialApp(
          //theme: ThemeProvider.of(context),
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
            backgroundColor: Colors.orange[300],
          ),
          initialRoute: initialroute,
          routes: {cartegoryset: (context) => const CartegoryEvents()},
          onGenerateRoute: Routegenerator.Generateroute,
          // routes: {'/DialogBox': ()=>DialogBox(onPress: null,)},
          // onGenerateRoute: ,
        );
      }),
    );
  }
}

class OurApp extends StatelessWidget {
  // This widget is the root of your application.
  static final String title = 'User Profile';

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();
    // Ouruser ouruser = Provider.of<Ouruser>(
    //   context,
    // );
    return StreamProvider<Ouruser>.value(
        value: AuthService().user,
        initialData: Ouruser(uid: "them"),
        child: ThemeProvider(
            initTheme:
                user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
            child: Builder(builder: (context) {
              return MaterialApp(
                //theme: ThemeProvider(),
                debugShowCheckedModeBanner: false,
                home: Wrapper(),
              );
            })));
  }
}
