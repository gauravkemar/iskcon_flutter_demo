import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LiveLocation extends StatefulWidget {
  const LiveLocation({Key? key}) : super(key: key);

  @override
  State<LiveLocation> createState() => _LiveLocationState();
}

class _LiveLocationState extends State<LiveLocation> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng sourceLocation = LatLng(19.1709554, 72.9342447);
  LatLng lastLatLng = LatLng(19.1709554, 72.9342447);
  String loc = "";
  late Timer tt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location"), centerTitle: true),
      body: initScreen(context),
    );
  }
  void getLocation(GoogleMapController controller) {
    Location location = Location();
    location.getLocation().then(
          (location) {
        sourceLocation = LatLng(location.latitude!, location.longitude!);
        loc = "${location.latitude} , ${location.longitude}";
        if (kDebugMode) {
          print(
              "Latitude/Longitude : ${location.latitude!},${location.longitude!}");
        }
        if (lastLatLng != sourceLocation) {
          print(
              "Latitude/Longitude Changed");
          //showShortToast("Latitude/Longitude Changed ${location.latitude!},${location.longitude!}");
          lastLatLng = sourceLocation;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 17,
                target: LatLng(
                  location.latitude!,
                  location.longitude!,
                ),
              ),
            ),
          );
          if (mounted) {
            setState(() {
            });
          }
        }
      },
    );
  }
  void _onMapCreated(GoogleMapController controller) {
    tt = Timer.periodic(Duration(seconds: 1), (timer) {
      getLocation(controller);
    });
  }
  @override
  void initState() {
    super.initState();
  }
  initScreen(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Stack(
      children: [GoogleMap(
        initialCameraPosition: CameraPosition(
          target: sourceLocation,
          zoom: 17,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: sourceLocation,
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
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        loc,
                        style:
                        const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ))),
          ),
        )
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




