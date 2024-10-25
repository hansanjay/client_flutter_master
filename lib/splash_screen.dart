import 'dart:async';
import 'package:client_flutter_master/utils/images_utils.dart';
import 'package:client_flutter_master/view/dashboard/dashboard.dart';
import 'package:client_flutter_master/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  runFun() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? login;
    String path;
    login = await prefs.getBool('Login');
    Timer(Duration(seconds: 3), () {
      if (login == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
    runFun();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child: Image.asset(
              brandLogoSplash,
              height: 100,
              width: 100,
            )),
      ),
    ));
  }
}