import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: "Cadence",
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.green[600],
        fontFamily: 'Gotham-Medium',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
