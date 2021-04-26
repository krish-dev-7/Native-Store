import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:nativestore/config.dart';
import 'package:nativestore/loginout/auth.dart';
import 'package:latlong/latlong.dart' as latLng;
import 'package:nativestore/loginout/loginpage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class homePage extends StatefulWidget {
  @override
  homePageState createState() => homePageState();
}

String email, item, custEmail;
int itemCount;

class homePageState extends State<homePage> {
  double lat, long;
  getSPData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      lat = pref.getDouble('lat');
      long = pref.getDouble('long');
      custEmail = pref.getString('_spemail');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSPData();
  }

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
                .setData(
              {item: itemCount},
            );
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Yup'),
        ),
      ],
    );
  }

  final AuthService _auth = AuthService();
  List<Marker> markersList = [];
  Widget MapLoad() {
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
                          print(
                              "shopkeeper --> ${snapshot.data.documents[i]['latitude']}\n email-->$email");
                          showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                try {
                                  return Container(
                                      decoration: BoxDecoration(
                                        color: dc,
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [Colors.black, pc]),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 70,
                                              width: 400,
                                              color: Colors.black,
                                              child: Center(
                                                child: Text(
                                                  snapshot.data.documents[i]
                                                      ['Shop Name'],
                                                  style: TextStyle(
                                                      color: pc,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                    padding: EdgeInsets.all(10),
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
                                                              .elementAt(index)
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
                                                              .elementAt(index)
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
                                      ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pc,
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
        animationDuration: Duration(milliseconds: 200),
        color: dc,
        buttonBackgroundColor: dc,
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
        onTap: (index) {
          //Handle button tap
        },
      ),
      body: MapLoad(),
    );
  }
}
