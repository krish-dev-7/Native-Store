import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nativestore/config.dart';
import 'package:nativestore/loginout/shopregistration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationGetter extends StatefulWidget {
  final FirebaseUser user;

  const LocationGetter({
    Key key,
    this.user,
  }) : super(key: key);
  @override
  _LocationGetterState createState() => _LocationGetterState();
}

class _LocationGetterState extends State<LocationGetter> {
  Position _currentPosition;
  String _currentAddress = " Tap > ";
  var lat, long;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 125,
        width: 400,
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
        child: Row(
          children: <Widget>[
            if (_currentAddress != null)
              Text(
                "$_currentAddress",
                // "k",
                style: TextStyle(
                    color: dc,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    decoration: TextDecoration.underline),
              ),
            OutlineButton(
              child: Icon(
                Icons.add_location_alt,
                size: 50,
                color: dc,
              ),
              onPressed: () async {
                // _getCurrentLocation();
                await getLocation();
                await Firestore.instance
                    .collection('/shopkeepers')
                    .document('${widget.user.email}')
                    .setData({
                  'latitude': _currentPosition.latitude,
                  'longitude': _currentPosition.longitude,
                  'address': _currentAddress,
                }, merge: true);
              },
            ),
          ],
        ),
      ),
    ]);
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];
      print("cur ad out of setstate : $_currentAddress");
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      _currentPosition = position;
      _getAddressFromLatLng();
    });
    return position;
  }
}

class CustLocationGetter extends StatefulWidget {
  final FirebaseUser user;

  const CustLocationGetter({Key key, this.user}) : super(key: key);

  @override
  _CustLocationGetterState createState() => _CustLocationGetterState();
}

class _CustLocationGetterState extends State<CustLocationGetter> {
  Position _currentPosition;
  String _currentAddress = " Tap > ";
  var lat, long;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 125,
        width: 400,
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
        child: Row(
          children: <Widget>[
            if (_currentAddress != null)
              Text(
                "$_currentAddress",
                // "k",
                style: TextStyle(
                    color: dc,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    decoration: TextDecoration.underline),
              ),
            OutlineButton(
              child: Icon(
                Icons.add_location_alt,
                size: 50,
                color: dc,
              ),
              onPressed: () async {
                // _getCurrentLocation();
                await getLocation();
                await Firestore.instance
                    .collection('/customers')
                    .document('${widget.user.email}')
                    .setData({
                  'latitude': _currentPosition.latitude,
                  'longitude': _currentPosition.longitude,
                  'address': _currentAddress,
                }, merge: true);
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setDouble("lat", _currentPosition.latitude);
                pref.setDouble("long", _currentPosition.longitude);
              },
            ),
          ],
        ),
      ),
    ]);
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];
      print("cur ad out of setstate : $_currentAddress");
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      _currentPosition = position;
      _getAddressFromLatLng();
    });
    return position;
  }
}
