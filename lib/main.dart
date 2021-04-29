import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nativestore/homepage.dart';
import 'package:nativestore/loginout/loginpage.dart';
import 'package:nativestore/shophomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginout/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: routePage(),
      theme: new ThemeData(
        canvasColor: Colors.transparent,
      ),
    );
  }
}

class routePage extends StatefulWidget {
  @override
  routePageState createState() => routePageState();
}

class routePageState extends State<routePage> {
  final AuthService _auth = AuthService();
  int type;
  bool isLoggedin = false;
  getIntValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int val = prefs.getInt('typeOfUser');
    return val;
  }

  @override
  void initState() {
    super.initState();
    getIntValuesSF().then((value) {
      type = value;
    });
    print("Init state");
    _auth.autoLogin().then((value) {
      if (value == 'null') {
        print(isLoggedin);
        setState(() {
          isLoggedin = false;
        });
      } else if (value != null) {
        setState(() {
          isLoggedin = true;
        });
      } else {
        setState(() {
          isLoggedin = false;
        });
      }
    });
  }

  // var Utype = GetUserType(type:"ko")
  @override
  Widget build(BuildContext context) {
    return isLoggedin == true
        ? (type == 2)
            ? HomePage()
            : ShopHomePage()
        : loginPage();
  }
}
