import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nativestore/config.dart';
import 'package:nativestore/database/add_get.dart';
import 'package:location/location.dart';
import 'package:nativestore/location_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../homepage.dart';

class CustReg extends StatefulWidget {
  final FirebaseUser username;
  final Position pos;
  final String address;

  const CustReg({Key key, this.username, this.pos, this.address})
      : super(key: key);
  @override
  _CustRegState createState() => _CustRegState();
}

String name;
String shopName;
String lat;
String long;
String number;

class _CustRegState extends State<CustReg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pc.withOpacity(0.9),
      body: Center(
          child: Container(
              child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: pc,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: dc,
                      offset: Offset(20, 8),
                      spreadRadius: 3,
                      blurRadius: 25),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -4),
                      spreadRadius: -2,
                      blurRadius: 20)
                ],
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Name",
                  fillColor: dc,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: pc,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: dc,
                      offset: Offset(20, 8),
                      spreadRadius: 3,
                      blurRadius: 25),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -4),
                      spreadRadius: -2,
                      blurRadius: 20)
                ],
              ),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    number = val;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Number",
                  fillColor: dc,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            CustLocationGetter(
              user: widget.username,
            ),
            Container(
                height: 70,
                width: 120,
                child: OutlineButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('cust_number', number);
                    prefs.setString('cust_Oname', name);
                    print(widget.pos);
                    setState(() {
                      print("-->${widget.username.email}");
                      UserManagement().custAddNewUser(
                        widget.pos,
                        widget.address,
                        widget.username,
                        name,
                        number,
                        context,
                      );
                    });
                    Future.delayed(Duration.zero, () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomePage()));
                    });
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: pc, fontSize: 15),
                  ),
                ),
                decoration: BoxDecoration(
                  color: dc,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: dc,
                        offset: Offset(20, 8),
                        spreadRadius: 3,
                        blurRadius: 25),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3, -4),
                        spreadRadius: -2,
                        blurRadius: 20)
                  ],
                )),
          ],
        ),
      ))),
    );
  }
}
