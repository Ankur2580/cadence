import 'dart:async';
import 'package:Cadence/auth/signup.dart';
import 'package:Cadence/news/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String name = '';
  String phone = '';

  Future getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name');
      phone = preferences.getString('phone');
    });
  }

  @override
  void initState() {
    super.initState();
    //Fetch Profile
    getProfile();

    Timer(Duration(seconds: 3), () {
      if (name != null) {
        //User is already registered
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => News(),
          ),
        );
        print(SignUp.fieldContact.text);
      } else {
        //No user information stored in share preferences so ask for signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignUp(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset('asset/images/cadence_logo.jpeg'),
    );
  }
}
