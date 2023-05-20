import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class LiveLocNew extends StatefulWidget {
  const LiveLocNew({Key? key}) : super(key: key);

  @override
  State<LiveLocNew> createState() => _LiveLocNewState();
}

class _LiveLocNewState extends State<LiveLocNew> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _sourceLocation = LatLng(19.1709554, 72.9342447);
  LatLng _lastLatLng = LatLng(19.1709554, 72.9342447);
  String _loc = "";
  late Timer _timer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Location"), centerTitle: true),
      body: _buildScreen(context),
    );
  }
  void _getLocation(GoogleMapController controller) {
    final location = Location();
    location.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
      interval: 1000,
    );
    location.getLocation().then(
          (location) {
        _sourceLocation = LatLng(location.latitude!, location.longitude!);
        _loc = "${location.latitude}, ${location.longitude}";
        if (kDebugMode) {
          print("Latitude/Longitude: ${location.latitude!}, ${location.longitude!}");
        }
        if (_lastLatLng != _sourceLocation) {
          print("Latitude/Longitude Changed");
          _lastLatLng = _sourceLocation;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 17,
                target: LatLng(location.latitude!, location.longitude!),
              ),
            ),
          );
          if (mounted) {
            setState(() {});
          }
        }
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _getLocation(controller);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildScreen(BuildContext context) {
    final queryData = MediaQuery.of(context);

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _sourceLocation,
            zoom: 17,
          ),
          markers: {
            Marker(
              markerId: const MarkerId("currentLocation"),
              position: _sourceLocation,
            ),
          },
          onMapCreated: _onMapCreated,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _loc,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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







