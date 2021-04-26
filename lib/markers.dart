import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' as latLng;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';

import 'config.dart';

class MarkersGroup extends StatefulWidget {
  @override
  _MarkersGroupState createState() => _MarkersGroupState();
}

class _MarkersGroupState extends State<MarkersGroup> {
  final StreamController _streamController = StreamController();

  addData() async {
    await Firestore.instance
        .collection('shopkeepers')
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        _streamController.sink.add(
          element.data,
        );
        print("debug-->${element.data}");
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FlutterMap>(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        return FlutterMap(
            options: MapOptions(
              center: latLng.LatLng(51.5, -0.09),
              zoom: 13.0,
            ),
            layers: [
              MarkerLayerOptions(
                markers: [
                  Marker(
                      width: 80.0,
                      height: 80.0,
                      // point: latLng.LatLng(
                      // snapshot.data['lat'], snapshot.data['longitude']),
                      builder: (ctx) => Container(
                            child: Icon(
                              Icons.circle,
                              size: 30,
                              color: dc,
                            ),
                          ))
                ],
              )
            ]);
      },
    );
  }
}
