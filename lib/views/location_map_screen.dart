import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapScreen extends StatefulWidget {
  @override
  _LocationMapScreenState createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  String loc = "";

  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Set<Marker> _markers = {};
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Text('Location Map'),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0),
                zoom: 15,
              ),
              markers: _markers,
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
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  void initState() {
    super.initState();

    /*geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        final marker = Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: 'Current Location'),
        );

        _markers = {marker};
      });
    }).catchError((e) {
      print(e);
    });*/

    Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      intervalDuration: Duration(seconds: 1),
    ).listen((Position position) {
      setState(() {
        getLocation(_controller!, position);
      });
    });
  }

  void getLocation(GoogleMapController controller, Position position) {
    final marker = Marker(
      markerId: MarkerId('current_location'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: 'Current Location'),
    );

    _markers = {marker};
    print(
        "Latitude/Longitude Changed ${position.latitude!},${position.longitude!}");
    loc = "${position.latitude!} , ${position.longitude!}";
    //showShortToast("Latitude/Longitude Changed ${position.latitude!},${position.longitude!}");
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 17,
          target: LatLng(
            position.latitude!,
            position.longitude!,
          ),
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
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
