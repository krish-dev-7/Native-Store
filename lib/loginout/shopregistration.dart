import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nativestore/config.dart';
import 'package:nativestore/database/add_get.dart';
import 'package:nativestore/location_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shophomepage.dart';

class AppDropdownInput<T> extends StatelessWidget {
  final String hintText;
  final List<T> options;
  final T value;
  final String Function(T) getLabel;
  final void Function(T) onChanged;

  AppDropdownInput({
    this.hintText = 'Please select an Option',
    this.options = const [],
    this.getLabel,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
            focusColor: dc,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            labelText: hintText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          isEmpty: value == null || value == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isDense: true,
              focusColor: dc,
              dropdownColor: pc,
              elevation: 100,
              onChanged: onChanged,
              items: options.map((T value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(getLabel(value)),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class ShopReg extends StatefulWidget {
  final FirebaseUser username;
  final Position pos;
  final String address;

  const ShopReg({Key key, this.username, this.pos, this.address})
      : super(key: key);
  @override
  _ShopRegState createState() => _ShopRegState();
}

String name;
String shopName;
String lat;
String long;
String number;
String shopType;

class _ShopRegState extends State<ShopReg> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await _auth.currentUser();
    final uemail = user.email;
    print(uemail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pc.withOpacity(1),
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
                borderRadius: BorderRadius.circular(10),
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
                borderRadius: BorderRadius.circular(10),
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
              child: AppDropdownInput(
                hintText: "Shop Type",
                options: ["Groceries", "Medical", "Mobile store", "Parlour"],
                value: shopType,
                onChanged: (String value) {
                  setState(() {
                    shopType = value;
                    // state.didChange(newValue);
                  });
                },
                getLabel: (String value) => value,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: pc,
                borderRadius: BorderRadius.circular(10),
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
                cursorColor: dc,
                onChanged: (val) {
                  setState(() {
                    shopName = val;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Shop Name",
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
                borderRadius: BorderRadius.circular(10),
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
            Text(
              "for confirmation You must register your shop while You're in your shop, so that we get shop's location ",
              style: TextStyle(color: Colors.red),
            ),
            LocationGetter(
              user: widget.username,
            ),
            Container(
                height: 60,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: OutlineButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setBool('isShopReg', true);
                      print(
                          "email in shopreg reg --> ${widget.username.email}");
                      setState(() {
                        UserManagement().shopAddNewUser(
                            widget.pos,
                            widget.address,
                            widget.username,
                            name,
                            shopType,
                            shopName,
                            number,
                            context);
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ShopHomePage()));
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: pc, fontSize: 15),
                    ),
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
