import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LiveLocStreamGeolocator extends StatefulWidget {
  const LiveLocStreamGeolocator({Key? key}) : super(key: key);

  @override
  State<LiveLocStreamGeolocator> createState() => _LiveLocStreamGeolocatorState();
}

class _LiveLocStreamGeolocatorState extends State<LiveLocStreamGeolocator> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _sourceLocation = LatLng(19.1709554, 72.9342447);
  LatLng _lastLatLng = LatLng(19.1709554, 72.9342447);
  String _loc = "";
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    try {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
        try {
          final position = await Geolocator
              .getPositionStream(
              forceAndroidLocationManager: true,
              distanceFilter: 10,
              intervalDuration: Duration(seconds: 1),
              desiredAccuracy: LocationAccuracy.high)
              .first;

          _onPositionChanged(position);
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
          showShortToast("Error fetching location.");
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      showShortToast("Error fetching location.");
    }
  }

  void _onPositionChanged(Position position) {
    _sourceLocation = LatLng(position.latitude, position.longitude);
    _loc = "${position.latitude}, ${position.longitude}";
    if (kDebugMode) {
      print("Latitude/Longitude: ${position.latitude}, ${position.longitude}");
    }
    if (_lastLatLng != _sourceLocation) {
      print("Latitude/Longitude Changed");
      _lastLatLng = _sourceLocation;
      if (_controller.isCompleted) {
        _controller.future.then((controller) {
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 17,
                target: LatLng(position.latitude, position.longitude),
              ),
            ),
          );
        });
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Loc Stream based"), centerTitle: true),
      body: _buildScreen(context),
    );
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
          onMapCreated: (controller) => _controller.complete(controller),
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
