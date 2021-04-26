import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nativestore/config.dart';
import 'package:nativestore/homepage.dart';
import 'package:nativestore/loginout/customerregistration.dart';
import 'package:nativestore/loginout/shopregistration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Role extends StatefulWidget {
  final FirebaseUser usern;
  const Role({Key key, this.usern}) : super(key: key);
  @override
  _RoleState createState() => _RoleState();
}

class _RoleState extends State<Role> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: dc,
      body: Center(
        child: Container(
          height: h,
          width: w / 1.01,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [dc, pc]),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(20, 8),
                    spreadRadius: 3,
                    blurRadius: 25),
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(-3, -4),
                    spreadRadius: -2,
                    blurRadius: 20),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                          color: dc,
                          offset: Offset(20, 8),
                          spreadRadius: 3,
                          blurRadius: 25),
                      BoxShadow(
                          color: Colors.white70,
                          offset: Offset(-3, -4),
                          spreadRadius: -2,
                          blurRadius: 20),
                    ]),
                child: Text(
                  "Select your Role :",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
              sph,
              sph,
              GestureDetector(
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setInt("typeOfUser", 1);
                  Firestore.instance
                      .collection('Type')
                      .document('${widget.usern.email}')
                      .setData({"type": 1});
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ShopReg(
                                username: widget.usern,
                              )));
                },
                child: Container(
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/shopkeeper.png"),
                  decoration: BoxDecoration(
                      color: dc,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(150.0),
                          bottomRight: Radius.circular(1.0),
                          topLeft: Radius.circular(150.0),
                          bottomLeft: Radius.circular(1.0)),
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
                            blurRadius: 20),
                      ]),
                ),
              ),
              sph,
              GestureDetector(
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setInt("typeOfUser", 2);
                  Firestore.instance
                      .collection('Type')
                      .document('${widget.usern.email}')
                      .setData({"type": 2});
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CustReg(
                                username: widget.usern,
                              )));
                },
                child: Container(
                  height: 150,
                  width: 150,
                  child: ClipRRect(
                      child: Image(
                          image: AssetImage('assets/customer.png'), height: 35),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(125),
                          bottomLeft: Radius.circular(125))),
                  decoration: BoxDecoration(
                      color: dc,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(1.0),
                          bottomRight: Radius.circular(150.0),
                          topLeft: Radius.circular(1.0),
                          bottomLeft: Radius.circular(150.0)),
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
                            blurRadius: 20),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
