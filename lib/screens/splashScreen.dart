import 'dart:async';

import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:darain_travels/screens/createProfileScreen.dart';
import 'package:darain_travels/screens/dashboardScreen.dart';
import 'package:darain_travels/screens/loginScreen.dart';
import 'package:darain_travels/screens/main_screen.dart';
import 'package:darain_travels/utils/myColors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String LOGGED_IN = 'logged_in';

  @override
  void initState() {
    whereToJump();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset("assets/images/splash_logo.png"),
      ),
    );
  }

  void whereToJump() async {
    var prefs = await SharedPreferences.getInstance();
    var loggedIn = prefs.getBool(LOGGED_IN);
    var isProfile = prefs.getInt(BasicConstants.IS_PROFILE);
    Timer(
      const Duration(seconds: 2),
      () {
        if (loggedIn != null) {
          if (loggedIn) {
            if (isProfile == 0) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            }
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          }
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      },
    );
  }
}
