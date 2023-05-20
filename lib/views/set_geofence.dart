import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetGeofence extends StatefulWidget {
  @override
  _SetGeofenceState createState() => _SetGeofenceState();
}

class _SetGeofenceState extends State<SetGeofence> {

  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
  }

  late Timer tt;

  void _onMapCreated(GoogleMapController controller) {
    tt = Timer.periodic(Duration(seconds: 5), (timer) {
      _getCurrentLocation();
    });
  }


  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Set Geofence"),centerTitle: true),
      body: initScreen(context),
    );
  }


  initScreen(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentPosition.latitude,_currentPosition.longitude),
        zoom: 17,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: LatLng(_currentPosition.latitude,_currentPosition.longitude),
        ),
      },
      onMapCreated: _onMapCreated,
    );

    /*return Center(
      child: Container(
        width: queryData.size.width,
        height: queryData.size.height,
        color: Colors.white,
        alignment: Alignment.center,
        child: GoogleMap(
          onMapCreated: (mapController) {
            _controller.complete(mapController);
          },
          initialCameraPosition: CameraPosition(
            target: sourceLocation,
            zoom: 13.5,
          ),
        ),
      ),
    );*/
  }

  void showShortToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
