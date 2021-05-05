import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nativestore/config.dart';
import 'package:nativestore/loginout/auth.dart';
import 'package:latlong/latlong.dart' as latLng;
import 'package:nativestore/loginout/loginpage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:nativestore/shophomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

String email, item, custEmail, custUName, custNumber, custName, picUrl;
int itemCount;
double lat, long;
List<Marker> markersList = [];
List<Widget> nav = [MapLoad(), ListLoad()];

class HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getSPData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      lat = pref.getDouble('lat');
      long = pref.getDouble('long');
      custEmail = pref.getString('_spemail');
      custUName = pref.getString('cust_name');
      custName = pref.getString('cust_Oname');
      custNumber = pref.getString('cust_number');
      picUrl = pref.getString('pic_Url');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSPData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: pc,
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
              title: Text(custUName),
              subtitle: Text(custEmail),
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
      appBar: AppBar(
        backgroundColor: dc,
        title: Text(
          "select the shop ",
          style: TextStyle(color: pc),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: pc,
          animationDuration: Duration(milliseconds: 200),
          color: dc,
          buttonBackgroundColor: dc,
          index: _selectedIndex,
          items: <Widget>[
            Icon(
              Icons.map_sharp,
              size: 35,
              color: pc,
            ),
            Icon(
              Icons.list,
              size: 35,
              color: pc,
            ),
          ],
          onTap: _onItemTap),
      body: nav[_selectedIndex],
    );
  }
}

class MapLoad extends StatefulWidget {
  @override
  _MapLoadState createState() => _MapLoadState();
}

class _MapLoadState extends State<MapLoad> {
  @override
  Widget build(BuildContext context) {
    Widget _buildPopupDialog(BuildContext context) {
      return new AlertDialog(
        title: const Text('confirm'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Are you Sure to buy this ?"),
            new TextField(
              decoration: InputDecoration(hintText: "number of items"),
              onChanged: (val) {
                setState(() {
                  itemCount = int.parse(val);
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
            child: const Text('Nah'),
          ),
          new FlatButton(
            onPressed: () {
              print("eee-->$email");
              Firestore.instance
                  .collection('shopkeepers')
                  .document(email)
                  .collection('ordered-customers')
                  .document(custEmail)
                  .setData({
                "email": custEmail,
                "number": custNumber,
                "user name": custUName,
                "name": custName,
              }, merge: true);
              Firestore.instance
                  .collection('shopkeepers')
                  .document(email)
                  .collection('ordered-customers')
                  .document(custEmail)
                  .updateData({
                "items.$item": itemCount,
              });
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Yup'),
          ),
        ],
      );
    }

    return StreamBuilder(
        stream: Firestore.instance.collection('shopkeepers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "OOPs, Error",
                style: TextStyle(color: dc, fontSize: 30),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              markersList.add(new Marker(
                  width: 45,
                  height: 45,
                  point: new latLng.LatLng(
                      snapshot.data.documents[i]['latitude'],
                      snapshot.data.documents[i]['longitude']),
                  builder: (ctx) => IconButton(
                        icon: Icon(Icons.circle),
                        onPressed: () {
                          setState(() {
                            email = snapshot.data.documents[i]['email'];
                          });
                          showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                try {
                                  return SingleChildScrollView(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: dc,
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(80.0),
                                            topRight:
                                                const Radius.circular(80.0),
                                            bottomLeft:
                                                const Radius.circular(80.0),
                                            bottomRight:
                                                const Radius.circular(80.0),
                                          ),
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white30.withOpacity(0.5),
                                                pc
                                              ]),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            sph,
                                            sph,
                                            sph,
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      new BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            80.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            80.0),
                                                    bottomLeft:
                                                        const Radius.circular(
                                                            80.0),
                                                    bottomRight:
                                                        const Radius.circular(
                                                            80.0),
                                                  ),
                                                ),
                                                height: 70,
                                                width: 400,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      spw,
                                                      Text(
                                                        snapshot.data
                                                                .documents[i]
                                                            ['Shop Name'],
                                                        style: TextStyle(
                                                            color: pc,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      IconButton(
                                                          icon: Icon(
                                                            Icons.info,
                                                            color: pc,
                                                          ),
                                                          onPressed: () async {
                                                            showDialog<void>(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false, // user must tap button!
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      '${snapshot.data.documents[i]['Shop Type']}'),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        ListBody(
                                                                      children: <
                                                                          Widget>[
                                                                        sph,
                                                                        Text(
                                                                            'shop owner : ${snapshot.data.documents[i]['name']}'),
                                                                        sph,
                                                                        Text(
                                                                            'username : ${snapshot.data.documents[i]['user name']}'),
                                                                        sph,
                                                                        Text(
                                                                            'Number : ${snapshot.data.documents[i]['number']}'),
                                                                        sph,
                                                                        Text(
                                                                          "email : $email",
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      child: Text(
                                                                          'OK'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot.data
                                                  .documents[i]['items'].length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      item = snapshot
                                                          .data
                                                          .documents[i]['items']
                                                          .keys
                                                          .elementAt(index)
                                                          .toString();
                                                    });
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          _buildPopupDialog(
                                                              context),
                                                    );
                                                  },
                                                  child: Card(
                                                    color: pc,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            snapshot
                                                                .data
                                                                .documents[i]
                                                                    ['items']
                                                                .keys
                                                                .elementAt(
                                                                    index)
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: dc,
                                                                fontSize: 20),
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data
                                                                .documents[i]
                                                                    ['items']
                                                                .values
                                                                .elementAt(
                                                                    index)
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: dc,
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        )),
                                  );
                                } catch (e) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: dc,
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [Colors.black, pc]),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          "Something went wrong :(",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                        },
                        color: dc,
                      )));
            }
            try {
              return new FlutterMap(
                options: MapOptions(
                  center: latLng.LatLng(lat, long),
                  zoom: 13.0,
                ),
                layers: [
                  new TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  new MarkerLayerOptions(
                    markers: markersList,
                  ),
                ],
              );
            } catch (e) {
              print(e);
              return new FlutterMap(
                options: MapOptions(
                  center: latLng.LatLng(10.0, 10.0),
                  zoom: 13.0,
                ),
                layers: [
                  new TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  new MarkerLayerOptions(
                    markers: markersList,
                  ),
                ],
              );
            }
          }
        });
  }
}

class ListLoad extends StatefulWidget {
  @override
  _ListLoadState createState() => _ListLoadState();
}

class _ListLoadState extends State<ListLoad> {
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('confirm'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Are you Sure to buy this ?"),
          new TextField(
            decoration: InputDecoration(hintText: "number of items"),
            onChanged: (val) {
              setState(() {
                itemCount = int.parse(val);
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
          child: const Text('Nah'),
        ),
        new FlatButton(
          onPressed: () {
            print("eee-->$email");
            Firestore.instance
                .collection('shopkeepers')
                .document(email)
                .collection('ordered-customers')
                .document(custEmail)
                .setData({
              "email": custEmail,
              "number": custNumber,
              "user name": custUName,
              "name": custName,
            }, merge: true);
            Firestore.instance
                .collection('shopkeepers')
                .document(email)
                .collection('ordered-customers')
                .document(custEmail)
                .updateData({
              "items.$item": itemCount,
            });
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Yup'),
        ),
      ],
    );
  }

  double range = 50;
  @override
  Widget build(BuildContext context) {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 200,
            height: 50,
            padding: EdgeInsets.all(8),
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
            ),
            child: TextField(
              style: TextStyle(color: pc),
              onChanged: (val) {
                setState(() {
                  range = double.parse(val);
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: pc),
                ),
                labelText: "Enter Range",
                hintText: "Km from shop",
                labelStyle: TextStyle(color: pc.withOpacity(0.9)),
                hintStyle: TextStyle(color: Colors.white70),
                fillColor: pc,
                hoverColor: pc,
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height - 205,
              width: double.infinity,
              color: pc,
              child: StreamBuilder(
                stream:
                    Firestore.instance.collection('shopkeepers').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return new Text("Loading");
                  }
                  var userDocument = snapshot.data;
                  try {
                    return ListView.builder(
                      itemCount: userDocument.documents.length,
                      itemBuilder: (context, index) {
                        if (calculateDistance(
                                lat,
                                long,
                                userDocument.documents[index]['latitude'],
                                userDocument.documents[index]['longitude']) <
                            range) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      email = userDocument.documents[index]
                                          ['email'];
                                    });
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          try {
                                            return SingleChildScrollView(
                                              child: Container(
                                                  height: 800,
                                                  decoration: BoxDecoration(
                                                    color: dc,
                                                    borderRadius:
                                                        new BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              80.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              80.0),
                                                      bottomLeft:
                                                          const Radius.circular(
                                                              80.0),
                                                      bottomRight:
                                                          const Radius.circular(
                                                              80.0),
                                                    ),
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Colors.white30
                                                              .withOpacity(0.5),
                                                          pc
                                                        ]),
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      sph,
                                                      sph,
                                                      sph,
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .only(
                                                              topLeft: const Radius
                                                                      .circular(
                                                                  80.0),
                                                              topRight: const Radius
                                                                      .circular(
                                                                  80.0),
                                                              bottomLeft:
                                                                  const Radius
                                                                          .circular(
                                                                      80.0),
                                                              bottomRight:
                                                                  const Radius
                                                                          .circular(
                                                                      80.0),
                                                            ),
                                                          ),
                                                          height: 70,
                                                          width: 400,
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                spw,
                                                                Text(
                                                                  userDocument.documents[
                                                                          index]
                                                                      [
                                                                      'Shop Name'],
                                                                  style: TextStyle(
                                                                      color: pc,
                                                                      fontSize:
                                                                          25,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .info,
                                                                      color: pc,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      showDialog<
                                                                          void>(
                                                                        context:
                                                                            context,
                                                                        barrierDismissible:
                                                                            false,
                                                                        // user must tap button!
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                Text('${userDocument.documents[index]['Shop Type']}'),
                                                                            content:
                                                                                SingleChildScrollView(
                                                                              child: ListBody(
                                                                                children: <Widget>[
                                                                                  sph,
                                                                                  Text('shop owner : ${userDocument.documents[index]['name']}'),
                                                                                  sph,
                                                                                  Text('username : ${userDocument.documents[index]['user name']}'),
                                                                                  sph,
                                                                                  Text('Number : ${userDocument.documents[index]['number']}'),
                                                                                  sph,
                                                                                  Text(
                                                                                    "email : $email",
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                child: Text('OK'),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                              ),
                                                                            ],
                                                                          );
                                                                        },
                                                                      );
                                                                    }),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: userDocument
                                                            .documents[index]
                                                                ['items']
                                                            .length,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                item = userDocument
                                                                    .documents[
                                                                        index][
                                                                        'items']
                                                                    .keys
                                                                    .elementAt(
                                                                        i)
                                                                    .toString();
                                                              });
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    _buildPopupDialog(
                                                                        context),
                                                              );
                                                            },
                                                            child: Card(
                                                              color: pc,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      userDocument
                                                                          .documents[
                                                                              index]
                                                                              [
                                                                              'items']
                                                                          .keys
                                                                          .elementAt(
                                                                              i)
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color:
                                                                              dc,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    Text(
                                                                      userDocument
                                                                          .documents[
                                                                              index]
                                                                              [
                                                                              'items']
                                                                          .values
                                                                          .elementAt(
                                                                              i)
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color:
                                                                              dc,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          } catch (e) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: dc,
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [Colors.black, pc]),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: Text(
                                                    "Something went wrong :(",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                  },
                                  child: (userDocument.documents[index]
                                              ['Shop Name'] !=
                                          null)
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: dc,
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                                            child: Text(
                                              userDocument.documents[index]
                                                  ['Shop Name'],
                                              style: TextStyle(
                                                  color: pc, fontSize: 30),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: dc,
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                                              child: Text(
                                            "no Data",
                                            style: TextStyle(
                                                color: pc, fontSize: 30),
                                          )),
                                        ),
                                ),
                              ),
                              sph,
                            ],
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              Image.asset('assets/oops.png'),
                              sph,
                              sph,
                              Text(
                                "no shops founded in your Surroundings :( , \nKindly share this app !",
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          );
                        }
                      },
                    );
                  } catch (e) {
                    return Container();
                  }
                },
              )),
        ],
      ),
    );
  }
}
