import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LiveLocUsingGetCurrentPost extends StatefulWidget {
  const LiveLocUsingGetCurrentPost({Key? key}) : super(key: key);

  @override
  State<LiveLocUsingGetCurrentPost> createState() => _LiveLocUsingGetCurrentPostState();
}

class _LiveLocUsingGetCurrentPostState extends State<LiveLocUsingGetCurrentPost> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _sourceLocation = LatLng(19.1709554, 72.9342447);
  LatLng _lastLatLng = LatLng(19.1709554, 72.9342447);
  String _loc = "";
  late Timer _timer;

  Future<void> _getLocation(GoogleMapController controller) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
      _sourceLocation = LatLng(position.latitude, position.longitude);
      _loc = "${position.latitude}, ${position.longitude}";
      if (kDebugMode) {
        print("Latitude/Longitude: ${position.latitude}, ${position.longitude}");
      }
      if (_lastLatLng != _sourceLocation) {
        print("Latitude/Longitude Changed");
        _lastLatLng = _sourceLocation;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 17,
              target: LatLng(position.latitude, position.longitude),
            ),
          ),
        );
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      showShortToast("Error fetching location.");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _getLocation(controller);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Current Position "), centerTitle: true),
      body: _buildScreen(context),
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

/*
 try {
      final position = await Geolocator.getPositionStream(
        forceAndroidLocationManager: Platform.isAndroid,
        desiredAccuracy: LocationAccuracy.high,
        distanceFilter: 10,
        intervalDuration:Duration(seconds: 1) ,
      );

      _sourceLocation = LatLng(position.latitude, position.longitude);
      _loc = "${position.latitude}, ${position.longitude}";
      if (kDebugMode) {
        print("Latitude/Longitude: ${position.latitude}, ${position.longitude}");
      }
      if (_lastLatLng != _sourceLocation) {
        print("Latitude/Longitude Changed");
        _lastLatLng = _sourceLocation;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 17,
              target: LatLng(position.latitude, position.longitude),
            ),
          ),
        );
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      showShortToast("Error fetching location.");
    }*/