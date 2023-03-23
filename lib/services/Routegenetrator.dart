import 'package:flutter/material.dart';
import 'package:grouptour/screens/home/home.dart';
import 'package:grouptour/screens/home/settings/CartegoryEvents.dart';
import 'package:grouptour/screens/home/settings/incomeset.dart';
import 'package:grouptour/services/initialisation.dart';
import 'package:grouptour/shared/loading.dart';
import 'package:grouptour/shared/routeconstants.dart';

class Routegenerator {
  static Route<dynamic>? Generateroute(RouteSettings settings) {
    final agrs = settings.arguments;
    print("Route genetrator has been used");
    switch (settings.name) {
      case initialroute:
        print("/ route used");
        print(settings);
        return MaterialPageRoute(builder: (_) => FireBase());
      case incomeset:
        print("/Income route taken");
        return MaterialPageRoute(builder: (_) => const Incomeset());

      case cartegoryset:
        print("/Cartegoryset taken");

        return MaterialPageRoute(builder: (_) => const CartegoryEvents());
      case navScreen:
        print("navsreen");
        return MaterialPageRoute(builder: (_) => const BottomAppBar());

      default:
        print("defualt route taken");
        print(settings);
        MaterialPageRoute(builder: (_) => const defualtRoute());
    }
  }
}

// Route<dynamic> _errorroute() {
//   return MaterialPageRoute(builder: (_) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ERROR"),
//       ),
//       body: const SafeArea(
//         child: Text(
//           'ERROR',
//         ),
//       ),
//     );
//   });
// }
class defualtRoute extends StatelessWidget {
  const defualtRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ERROR"),
      ),
      body: const SafeArea(
        child: Text(
          'ERROR',
        ),
      ),
    );
  }
}
