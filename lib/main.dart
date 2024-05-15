import 'package:flutter/material.dart';
import 'package:freetime/activity_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Freetime',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: myColor,
      ),
      home: const ActivityListScreen(),
    );
  }
}

Map<int, Color> color = {
  50: const Color.fromRGBO(252, 92, 98, .1),
  100: const Color.fromRGBO(252, 92, 98, .2),
  200: const Color.fromRGBO(252, 92, 98, .3),
  300: const Color.fromRGBO(252, 92, 98, .4),
  400: const Color.fromRGBO(252, 92, 98, .5),
  500: const Color.fromRGBO(252, 92, 98, .6),
  600: const Color.fromRGBO(252, 92, 98, .7),
  700: const Color.fromRGBO(252, 92, 98, .8),
  800: const Color.fromRGBO(252, 92, 98, .9),
  900: const Color.fromRGBO(252, 92, 98, 1),
};
MaterialColor myColor = MaterialColor(0xFFE86767, color);
