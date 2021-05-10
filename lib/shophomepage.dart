import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'loginout/auth.dart';
import 'main.dart';

class ShopHomePage extends StatefulWidget {
  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

String userEmail;
String picUrl;
String sUserName;

class _ShopHomePageState extends State<ShopHomePage> {
  @override
  final AuthService _auth = AuthService();
  getSpData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userEmail = pref.getString('_spemail');
      picUrl = pref.getString('pic_Url');
      sUserName = pref.getString('cust_name');
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getSpData();
  }

  List<Widget> nav = [AddItem(), ShowOrders()];
  int _currIndex = 1;
  void _onItemTap(int index) {
    setState(() {
      _currIndex = index;
    });
  }

  Widget _buildLogoutDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Logout'),
      content: Text("If you logout, you have to re-register to update data, "
          "but your items list and order list won't delete."),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.arrow_back),
        ),
        new FlatButton(
          onPressed: () {
            _auth.logOut();
            _auth.signOut();
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => routePage()));
          },
          textColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildDelDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Are you sure to delete?'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.arrow_back),
        ),
        new FlatButton(
          onPressed: () {
            _auth.signOut();
            _auth.logOut();
            Firestore.instance
                .collection('shopkeepers')
                .document(userEmail)
                .delete()
                .whenComplete(() {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => routePage()));
            });
          },
          textColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.delete_forever_rounded,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: dc),
          backgroundColor: pc,
          centerTitle: true,
          title: Text(
            "Native Store",
            style:
                TextStyle(color: dc, fontSize: 25, fontStyle: FontStyle.italic),
          ),
        ),
        drawer: Drawer(
            child: Container(
          color: pc,
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage((picUrl != null)
                        ? picUrl
                        : "https://firebasestorage.googleapis.com/v0/b/native-store-c3ca3.appspot.com/o/Drawing-1.sketchpad%20(1).png?alt=media&token=d544c748-938a-43ae-bb91-372362383974")),
                title: Text(sUserName),
                subtitle: Text(userEmail),
              ),
              sph,
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildLogoutDialog(context));
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever_rounded),
                title: Text("Delete my Account"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildDelDialog(context));
                },
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("Contact Us"),
                onTap: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          color: Colors.black87,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    text: "Mail :",
                                    style: TextStyle(
                                        fontSize: 25, color: Color(0xFFE50914)),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " krish0cyber@gmail.com",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Color(0xFFE50914),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Developer :",
                                    style: TextStyle(
                                        fontSize: 25, color: Color(0xFFE50914)),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " Krishna Sundar\n\n",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Color(0xFFE50914),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Instagram:",
                                    style: TextStyle(
                                        fontSize: 25, color: Color(0xFFE50914)),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " krish_krush",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Color(0xFFE50914),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Youtube:",
                                    style: TextStyle(
                                        fontSize: 25, color: Color(0xFFE50914)),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " code with krish",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Color(0xFFE50914),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Github:",
                                    style: TextStyle(
                                        fontSize: 25, color: Color(0xFFE50914)),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " github.com/krish-dev-7",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Color(0xFFE50914),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        )),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: dc,
          animationDuration: Duration(milliseconds: 500),
          color: pc,
          index: _currIndex,
          buttonBackgroundColor: pc,
          items: <Widget>[
            Icon(
              Icons.add,
              size: 35,
              color: dc,
            ),
            Icon(
              Icons.people,
              size: 35,
              color: dc,
            ),
          ],
          onTap: _onItemTap,
        ),
        body: nav[_currIndex]);
  }
}

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String additName;
  var quantity;
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Add Items'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(" Enter Details "),
          new TextField(
            decoration: InputDecoration(
                labelText: "Items", hintText: "example: ball 30.rs"),
            onChanged: (val) {
              setState(() {
                additName = val;
              });
            },
          ),
          new TextField(
            decoration:
                InputDecoration(hintText: "5 pieces", labelText: "Quantity"),
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

  Widget _buildEditDialog(BuildContext context, itemName) {
    return new AlertDialog(
      title: const Text('Edit Quantity'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(" Enter Quantity "),
          new TextField(
            decoration: InputDecoration(hintText: "eg : 3kg (or) 4 packets"),
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
          child: const Icon(Icons.close),
        ),
        new FlatButton(
          onPressed: () {
            Firestore.instance
                .collection('shopkeepers')
                .document(userEmail)
                .updateData({"items.$itemName": quantity});
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.edit),
        ),
      ],
    );
  }

  Widget _buildDelDialog(BuildContext context, var itemName) {
    return new AlertDialog(
      title: const Text('Are you sure to delete?'),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.arrow_back),
        ),
        new FlatButton(
          onPressed: () {
            Firestore.instance
                .collection('shopkeepers')
                .document(userEmail)
                .updateData({
              "items.$itemName": FieldValue.delete()
            }).whenComplete(() => Navigator.of(context).pop());
          },
          textColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.delete_forever_rounded,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dc,
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                color: pc,
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
                    color: dc,
                  ),
                  Text(
                    "Add Item",
                    style: TextStyle(color: dc, fontSize: 25),
                  ),
                ],
              ),
              height: 50,
              width: 150,
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
                try {
                  return Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
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
                                color: dc,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      sph,
                      sph,
                      sph,
                      SingleChildScrollView(
                        child: Container(
                          height: 300,
                          child: new ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: userDocument['items'].length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: pc,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        userDocument['items']
                                            .keys
                                            .elementAt(index),
                                        style:
                                            TextStyle(color: dc, fontSize: 20),
                                      ),
                                      Row(
                                        children: [
                                          FlatButton(
                                            color: dc.withOpacity(0.3),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    _buildEditDialog(
                                                        context,
                                                        userDocument['items']
                                                            .keys
                                                            .elementAt(index)),
                                              );
                                            },
                                            child: Text(
                                              userDocument['items']
                                                  .values
                                                  .elementAt(index),
                                              style: TextStyle(
                                                  color: dc, fontSize: 25),
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.delete_forever),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      _buildDelDialog(
                                                          context,
                                                          userDocument['items']
                                                              .keys
                                                              .elementAt(
                                                                  index)),
                                                );
                                              })
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } catch (e) {
                  return Container(
                    child: Center(
                      child: Text(
                        "Re-login needed, Kindly give correct info while registering",
                        style: TextStyle(color: pc),
                      ),
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}

class ShowOrders extends StatefulWidget {
  @override
  _ShowOrdersState createState() => _ShowOrdersState();
}

class _ShowOrdersState extends State<ShowOrders> {
  String currCustEmail;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: dc,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('shopkeepers')
              .document(userEmail)
              .collection('ordered-customers')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            var orderedUsers = snapshot.data;
            return ListView.builder(
              itemCount: orderedUsers.documents.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      currCustEmail = orderedUsers.documents[index]['email'];
                    });
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Info'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                sph,
                                Text(
                                    'name :${orderedUsers.documents[index]['name']}'),
                                sph,
                                Text(
                                    'username : ${orderedUsers.documents[index]['user name']}'),
                                sph,
                                Text(
                                    'Number : ${orderedUsers.documents[index]['number']}'),
                                sph,
                                Text(
                                  "email : $currCustEmail}",
                                ),
                                sph,
                                sph,
                                Text(
                                  "If Order sold to that user, then don't forget to update the sold items in homepage !",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('ok, back'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                'ok, close order',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Firestore.instance
                                    .collection('shopkeepers')
                                    .document(userEmail)
                                    .collection('ordered-customers')
                                    .document(currCustEmail)
                                    .delete();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: pc,
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
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(orderedUsers.documents[index]['user name']),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: orderedUsers
                                    .documents[index]['items'].length,
                                itemBuilder: (context, i) {
                                  try {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(orderedUsers
                                            .documents[index]['items'].keys
                                            .elementAt(i)
                                            .toString()),
                                        Text(orderedUsers
                                            .documents[index]['items'].values
                                            .elementAt(i)
                                            .toString()),
                                      ],
                                    );
                                  } catch (e) {
                                    return Text("NO orders found");
                                  }
                                }),
                          ]),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
