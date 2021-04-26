import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'loginout/auth.dart';
import 'loginout/loginpage.dart';
import 'main.dart';

class ShopHomePage extends StatefulWidget {
  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

String userEmail;

class _ShopHomePageState extends State<ShopHomePage> {
  @override
  final AuthService _auth = AuthService();
  getSpData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userEmail = pref.getString('_spemail');
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getSpData();
  }

  String additName;
  var quantity;
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Add Items'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(" Enter Details "),
          new TextField(
            decoration: InputDecoration(hintText: "Items"),
            onChanged: (val) {
              setState(() {
                additName = val;
              });
            },
          ),
          new TextField(
            decoration: InputDecoration(hintText: "Quantity"),
            onChanged: (val) {
              setState(() {
                quantity = val;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Back'),
        ),
        new FlatButton(
          onPressed: () {
            Firestore.instance
                .collection('shopkeepers')
                .document(userEmail)
                .updateData({"items.$additName": quantity});
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Add'),
        ),
      ],
    );
  }

  Widget addItem() {
    return Container(
      color: pc,
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          sph,
          sph,
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(20, 8),
                      spreadRadius: 3,
                      blurRadius: 25),
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(-3, -4),
                      spreadRadius: -2,
                      blurRadius: 20)
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: pc,
                  ),
                  Text(
                    "Add Item",
                    style: TextStyle(color: pc, fontSize: 25),
                  ),
                ],
              ),
              height: 50,
              width: 200,
            ),
          ),
          sph,
          sph,
          sph,
          StreamBuilder(
              stream: Firestore.instance
                  .collection('shopkeepers')
                  .document(userEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Text("Loading");
                }
                var userDocument = snapshot.data;
                if (userDocument['items'] == null) {
                  return Text("No items added");
                }
                return Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              offset: Offset(20, 8),
                              spreadRadius: 3,
                              blurRadius: 25),
                          BoxShadow(
                              color: Colors.black54,
                              offset: Offset(-3, -4),
                              spreadRadius: -2,
                              blurRadius: 20)
                        ],
                      ),
                      height: 70,
                      width: 400,
                      child: Center(
                        child: Text(
                          userDocument['Shop Name'],
                          style: TextStyle(
                              color: pc,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    sph,
                    sph,
                    sph,
                    new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: userDocument['items'].length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: dc,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userDocument['items'].keys.elementAt(index),
                                  style: TextStyle(color: pc, fontSize: 25),
                                ),
                                Text(
                                  userDocument['items'].values.elementAt(index),
                                  style: TextStyle(color: pc, fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: dc,
          title: Text(
            "select the shop ",
            style: TextStyle(color: pc),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: pc,
              ),
              onPressed: () {
                _auth.logOut();
                _auth.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => routePage()));
              },
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: pc,
          animationDuration: Duration(milliseconds: 500),
          color: dc,
          buttonBackgroundColor: dc,
          items: <Widget>[
            Icon(
              Icons.add,
              size: 35,
              color: pc,
            ),
            Icon(
              Icons.list,
              size: 35,
              color: pc,
            ),
          ],
          onTap: (index) {
            //Handle button tap
            if (index == 0) {
              setState(() {
                addItem();
              });
            }
            if (index == 1) {
              setState(() {
                showOrders();
              });
            }
          },
        ),
        body: addItem());
  }
}

Widget showOrders() {
  return Container(
    height: 3000,
    color: pc,
    width: double.infinity,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("orders"),
        ],
      ),
    ),
  );
}
