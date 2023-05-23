import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iskcon_flutter_demo/bottomsheet/share_geofence_prefs.dart';
import 'package:location/location.dart';

class BottomSheetMap extends StatefulWidget {
  const BottomSheetMap({Key? key}) : super(key: key);

  @override
  State<BottomSheetMap> createState() => _BottomSheetMapState();
}

class _BottomSheetMapState extends State<BottomSheetMap> {
  String locationMessage = 'Current Location of user';

  GoogleMapController? _mapController;
  String? lat;
  String? long;
  LocationData? currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(19.236312694358414, 72.98651724421268),
    zoom: 14,
  );
  Set<Polygon> _polygone = HashSet<Polygon>();

  List<LatLng> points = [
    LatLng(19.236312694358414, 72.98651724421268),
    LatLng(19.236659640362213, 72.98709526025539),
    LatLng(19.23646464160359, 72.9880876775909),
    LatLng(19.235697306577514, 72.98748954498058),
    LatLng(19.235917630862893, 72.98635497056728)
  ];

  @override
  void initState() {
    super.initState();
    _polygone.add(Polygon(
        polygonId: PolygonId('1'),
        points: points,
        fillColor: Colors.transparent,
        geodesic: true,
        strokeColor: Colors.red,
        strokeWidth: 2));

    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateLocation());
  }

  Future<LocationData> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permission are permanently denied we cannot request");
    }

    /* Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);*/

    Position position = await Geolocator.getCurrentPosition(); // meters);
    return LocationData.fromMap({
      "latitude": position.latitude,
      "longitude": position.longitude,
    });
  }

  void _updateLocation() async {
    LocationData locationData = await _getCurrentLocation();
    setState(() {
      currentLocation = locationData;
      locationMessage =
          "Latitude:${currentLocation?.latitude}, Longitude:${currentLocation?.longitude}";
    });
    if (_mapController != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 18.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polygon'),
      ),
      body:
      Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  myLocationButtonEnabled: true,
                  polygons: _polygone,
                  myLocationEnabled: true,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    _getCurrentLocation().then((locationData) {
                      setState(() {
                        currentLocation = locationData;
                      });
                      if (_mapController != null) {
                        _mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(currentLocation!.latitude!,
                                  currentLocation!.longitude!),
                              zoom: 18.0,
                            ),
                          ),
                        );
                      }
                    });
                  },
                  markers: currentLocation != null
                      ? {
                    Marker(
                      markerId: MarkerId('current_location'),
                      position: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                      infoWindow: InfoWindow(
                          title: 'Your Location',
                          snippet:
                          'Latitude:${currentLocation?.latitude}, Longitude:${currentLocation?.longitude}'),
                    )
                  }
                      : {},
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle button 1 press
                              },
                              child: Text('Button 1'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                var preferencesUtil = GeoPrefs();
                               await preferencesUtil.savePolygonData(getPolygonData());
                                print("clicked");
                              },
                              child: Text('Button 2'),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Text(
                                    'Location',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )

      /* Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: true,
            polygons: _polygone,
            myLocationEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
              _getCurrentLocation().then((locationData) {
                setState(() {
                  currentLocation = locationData;
                });
                if (_mapController != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        zoom: 18.0,
                      ),
                    ),
                  );
                }
              });
            },
            markers: currentLocation != null
                ? {
                    Marker(
                      markerId: MarkerId('current_location'),
                      position: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                      infoWindow: InfoWindow(
                          title: 'Your Location',
                          snippet:
                              'Latitude:${currentLocation?.latitude}, Longitude:${currentLocation?.longitude}'),
                    )
                  }
                : {},
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button 1 press
                          },
                          child: Text('Button 1'),
                        ),
                      ),
                      SizedBox(width: 10), // Adjust the width as needed
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button 2 press
                          },
                          child: Text('Button 2'),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      *//*  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),*//*
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),*/
    );
  }


  Map<String, List<LatLng>> getPolygonData() {
    final json = '''
  {
    "SRI SRI RADHA GOVINDA TEMPLE": {
      "zza": [
        {
          "latitude": 19.655206929413318,
          "longitude": 72.96796806156635
        },
        {
          "latitude": 19.655255237757444,
          "longitude": 72.9679637029767
        },
        {
          "latitude": 19.655249554423598,
          "longitude": 72.96801801770926
        },
        {
          "latitude": 19.655205666449874,
          "longitude": 72.96801667660475
        }
      ],
      "zzb": [],
      "zzc": 2,
      "zzd": -16777216,
      "zze": 0,
      "zzf": 0,
      "zzg": true,
      "zzh": false,
      "zzi": true,
      "zzj": 0
    },
    "DAMODARA LILA": {
      "zza": [
        {
          "latitude": 19.65512578399207,
          "longitude": 72.96743161976337
        },
        {
          "latitude": 19.655081580243376,
          "longitude": 72.96740144491196
        },
        {
          "latitude": 19.65502727276403,
          "longitude": 72.96740278601646
        },
        {
          "latitude": 19.654970123594392,
          "longitude": 72.96743229031563
        },
        {
          "latitude": 19.654984647694683,
          "longitude": 72.96748660504818
        },
        {
          "latitude": 19.65502348386944,
          "longitude": 72.96750504523516
        },
        {
          "latitude": 19.655088210806454,
          "longitude": 72.96750638633966
        },
        {
          "latitude": 19.65512578399207,
          "longitude": 72.96747453510761
        }
      ],
      "zzb": [],
      "zzc": 2,
      "zzd": -16777216,
      "zze": 0,
      "zzf": 0,
      "zzg": true,
      "zzh": false,
      "zzi": true,
      "zzj": 0
    },
    "SHRI KRISHNA JANMABHUMI": {
      "zza": [
        {
          "latitude": 19.655479413543095,
          "longitude": 72.96701118350029
        },
        {
          "latitude": 19.655374903462285,
          "longitude": 72.96698436141014
        },
        {
          "latitude": 19.655390059006923,
          "longitude": 72.96689618378878
        },
        {
          "latitude": 19.655510671831966,
          "longitude": 72.96692032366991
        }
      ],
      "zzb": [],
      "zzc": 2,
      "zzd": -16777216,
      "zze": 0,
      "zzf": 0,
      "zzg": true,
      "zzh": false,
      "zzi": true,
      "zzj": 0
    },
    "CIRA GHATA SATISFYING THE GOPIS": {
      "zza": [
        {
          "latitude": 19.655299757198964,
          "longitude": 72.96777494251728
        },
        {
          "latitude": 19.655286180349318,
          "longitude": 72.96774376183748
        },
        {
          "latitude": 19.655248291460495,
          "longitude": 72.96773672103882
        },
        {
          "latitude": 19.65521387571207,
          "longitude": 72.96775616705418
        },
        {
          "latitude": 19.655212612748677,
          "longitude": 72.96778567135334
        },
        {
          "latitude": 19.65523218868003,
          "longitude": 72.96781148761511
        },
        {
          "latitude": 19.65527007757266,
          "longitude": 72.96781182289124
        }
      ],
      "zzb": [],
      "zzc": 2,
      "zzd": -16777216,
      "zze": 0,
      "zzf": 0,
      "zzg": true,
      "zzh": false,
      "zzi": true,
      "zzj": 0
    },
    "FOREST AREA": {
      "zza": [
        {
          "latitude": 19.655522354221215,
          "longitude": 72.96678017824888
        },
        {
          "latitude": 19.655636020666627,
          "longitude": 72.96681437641382
        },
        {
          "latitude": 19.65648977939324,
          "longitude": 72.96717882156372
        },
        {
          "latitude": 19.657145250834937,
          "longitude": 72.96796001493931
        },
        {
          "latitude": 19.6571465137831,
          "longitude": 72.96887163072824
        },
        {
          "latitude": 19.656643228150063,
          "longitude": 72.96978760510683
        },
        {
          "latitude": 19.655906609630648,
          "longitude": 72.97011852264404
        },
        {
          "latitude": 19.65431716920553,
          "longitude": 72.96969037503004
        },
        {
          "latitude": 19.65352749499414,
          "longitude": 72.9689323157072
        },
        {
          "latitude": 19.6536945235701,
          "longitude": 72.96735819429159
        },
        {
          "latitude": 19.65451734989544,
          "longitude": 72.96668596565723
        }
      ],
      "zzb": [],
      "zzc": 2,
      "zzd": -16777216,
      "zze": 0,
      "zzf": 0,
      "zzg": true,
      "zzh": false,
      "zzi": true,
      "zzj": 0
    }
  }
  ''';

    Map<String, dynamic> data = jsonDecode(json);
    Map<String, List<LatLng>> polygonData = {};

    data.forEach((key, value) {
      List<dynamic> coordinates = value['zza'];
      List<LatLng> polygonPoints = coordinates.map((c) {
        return LatLng(c['latitude'], c['longitude']);
      }).toList();
      polygonData[key] = polygonPoints;
    });

    return polygonData;
  }


















}

/*showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return DraggableScrollableSheet(
                expand: true,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    // Your BottomSheet content
                    // ...
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 100,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text('Item $index'),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },*/

/*{
          showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return  Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: BottomSheetWidget(),
                  );
            },
          );
          */ /*showModalBottomSheet(context: context, builder: (BuildContext context){
            return SizedBox(
              height: 400,
              child: Center(
                child: ElevatedButton(
                  child: const Text('Close'),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          });*/ /*
        },*/
