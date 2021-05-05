import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nativestore/homepage.dart';

import '../shophomepage.dart';

class ShopAddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;

  ShopAddUser(this.fullName, this.company, this.age);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection

    CollectionReference users = Firestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': fullName, // John Doe
            'company': company, // Stokes and Sons
            'age': age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}

class UserManagement {
  shopAddNewUser(Position pos, address, FirebaseUser user, name, stype, sname,
      num, context) {
    Firestore.instance
        .collection('/shopkeepers')
        .document('${user.email}')
        .updateData({
      'Shop Name': sname,
      'Shop Type': stype,
      'number': num,
      'pic url': user.photoUrl,
      'name': name,
      'user name': user.displayName,
      'email': user.email,
      // 'items': {},
    }).then((val) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => ShopHomePage()));
    }).catchError((er) {
      print(er);
    });
  }

  custAddNewUser(Position pos, address, FirebaseUser user, name, num, context) {
    Firestore.instance
        .collection('/customers')
        .document('${user.email}')
        .updateData({
      'number': num,
      'name': name,
      'address': address,
      'user name': user.displayName,
      'pic url': user.photoUrl,
    }).then((val) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }).catchError((er) {
      print(er);
    });
  }
}
