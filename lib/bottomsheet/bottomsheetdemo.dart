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
  List<LatLng> updatedPoints = [];

  List<LatLng> points = [
    LatLng(19.236312694358414, 72.98651724421268),
    LatLng(19.236659640362213, 72.98709526025539),
    LatLng(19.23646464160359, 72.9880876775909),
    LatLng(19.235697306577514, 72.98748954498058),
    LatLng(19.235917630862893, 72.98635497056728)
  ];
  GeoPrefs geoPrefs = GeoPrefs();
  late List<LatLng> savedPolygonData;
  List<Polygon> polygons = [];
  @override
  void initState() {
    super.initState();
   // retrieveSavedPolygonData();
    /*points.addAll(  retrieveSavedPolygonData() as Iterable<LatLng>);

    _polygone.add(Polygon(
        polygonId: PolygonId('1'),
        points:   points,
        fillColor: Colors.transparent,
        geodesic: true,
        strokeColor: Colors.red,
        strokeWidth: 2));*/
   // initializePolygon();
    retrieveSavedPolygons();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateLocation());

  }
  Future<void> retrieveSavedPolygons() async {
    Map<String, List<LatLng>> savedPolygonData = await geoPrefs.getSavedPolygonData();
    savedPolygonData.forEach((key, value) {
      Polygon polygon = Polygon(
        polygonId: PolygonId(key),
        points: value,
        fillColor: Colors.transparent,
        geodesic: true,
        strokeColor: Colors.red,
        strokeWidth: 2,
      );
      polygons.add(polygon);
    });
    setState(() {});
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
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    myLocationButtonEnabled: true,
                    polygons:Set<Polygon>.of(polygons),
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
                                  await preferencesUtil
                                      .savePolygonData(getPolygonData());
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
                      */ /*  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),*/ /*
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
    const json = '''
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
  },
  "DELIVERANCE OF DHENUKASURA": {
    "zza": [
      {
        "latitude": 19.65577431473327,
        "longitude": 72.96733807772398
      },
      {
        "latitude": 19.655690959419694,
        "longitude": 72.96733807772398
      },
      {
        "latitude": 19.655613287383986,
        "longitude": 72.96729616820812
      },
      {
        "latitude": 19.655592448538727,
        "longitude": 72.96722609549761
      },
      {
        "latitude": 19.655613287383986,
        "longitude": 72.96715568751097
      },
      {
        "latitude": 19.655677698343098,
        "longitude": 72.96712785959244
      },
      {
        "latitude": 19.65575000277128,
        "longitude": 72.96714194118977
      },
      {
        "latitude": 19.655790101719603,
        "longitude": 72.96723313629627
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
  "SRILA GOPALA BHATTA GOSVAMI": {
    "zza": [
      {
        "latitude": 19.655355327548346,
        "longitude": 72.96835999935865
      },
      {
        "latitude": 19.65531428126941,
        "longitude": 72.96837843954563
      },
      {
        "latitude": 19.655273866461435,
        "longitude": 72.96838615089655
      },
      {
        "latitude": 19.655222716455487,
        "longitude": 72.96838514506817
      },
      {
        "latitude": 19.655178512733496,
        "longitude": 72.96837273985147
      },
      {
        "latitude": 19.655146307156958,
        "longitude": 72.96833284199238
      },
      {
        "latitude": 19.655141255301224,
        "longitude": 72.96828657388687
      },
      {
        "latitude": 19.655144728452065,
        "longitude": 72.96821348369122
      },
      {
        "latitude": 19.655180407178985,
        "longitude": 72.96817325055599
      },
      {
        "latitude": 19.65523218868003,
        "longitude": 72.96816151589155
      },
      {
        "latitude": 19.655292810903937,
        "longitude": 72.96816352754831
      },
      {
        "latitude": 19.655336067372613,
        "longitude": 72.96818364411592
      },
      {
        "latitude": 19.65536069513788,
        "longitude": 72.96824097633362
      },
      {
        "latitude": 19.65536890439214,
        "longitude": 72.96828523278236
      },
      {
        "latitude": 19.655366694208343,
        "longitude": 72.96832915395498
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
  "SRI SRI RADHA RAMAN TEMPLE": {
    "zza": [
      {
        "latitude": 19.655282707201543,
        "longitude": 72.96826377511024
      },
      {
        "latitude": 19.655279234053694,
        "longitude": 72.96832714229822
      },
      {
        "latitude": 19.65523218868003,
        "longitude": 72.9683281481266
      },
      {
        "latitude": 19.65522713682701,
        "longitude": 72.96825740486383
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
  "SRILA KRSNADASA KAVIRAJA GOSVAMI": {
    "zza": [
      {
        "latitude": 19.6555990790807,
        "longitude": 72.96756640076637
      },
      {
        "latitude": 19.655408687695253,
        "longitude": 72.96756573021412
      },
      {
        "latitude": 19.655369851613752,
        "longitude": 72.96753756701946
      },
      {
        "latitude": 19.655354696067203,
        "longitude": 72.9674869403243
      },
      {
        "latitude": 19.65536606272725,
        "longitude": 72.96745777130127
      },
      {
        "latitude": 19.655421317313227,
        "longitude": 72.96744100749493
      },
      {
        "latitude": 19.65547657188017,
        "longitude": 72.96744033694267
      },
      {
        "latitude": 19.655666963185045,
        "longitude": 72.96743463724852
      },
      {
        "latitude": 19.65575663330674,
        "longitude": 72.96744301915169
      },
      {
        "latitude": 19.65579578503429,
        "longitude": 72.96747218817472
      },
      {
        "latitude": 19.655799573910638,
        "longitude": 72.9675181210041
      },
      {
        "latitude": 19.655792627637265,
        "longitude": 72.96756874769926
      },
      {
        "latitude": 19.655731689862424,
        "longitude": 72.9675704240799
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
  "DELIVERANCE OF KESI": {
    "zza": [
      {
        "latitude": 19.655289337756315,
        "longitude": 72.96733036637306
      },
      {
        "latitude": 19.65545320709418,
        "longitude": 72.96729147434235
      },
      {
        "latitude": 19.655469309852457,
        "longitude": 72.96740848571062
      },
      {
        "latitude": 19.655299125717605,
        "longitude": 72.96744234859943
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
  "SRILA VALLABHACHARYA BAITHAKA": {
    "zza": [
      {
        "latitude": 19.656168041708444,
        "longitude": 72.96827483922243
      },
      {
        "latitude": 19.656100789294346,
        "longitude": 72.96827383339405
      },
      {
        "latitude": 19.656041114593457,
        "longitude": 72.96825036406517
      },
      {
        "latitude": 19.65603353685207,
        "longitude": 72.9681658744812
      },
      {
        "latitude": 19.65606542651131,
        "longitude": 72.96811625361443
      },
      {
        "latitude": 19.656156043627238,
        "longitude": 72.96811424195766
      },
      {
        "latitude": 19.656182565700266,
        "longitude": 72.96817392110825
      },
      {
        "latitude": 19.656182249961322,
        "longitude": 72.9682282358408
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
  "SRILA JIVA GOSVAMI": {
    "zza": [
      {
        "latitude": 19.65578662858273,
        "longitude": 72.96757612377405
      },
      {
        "latitude": 19.65541310806165,
        "longitude": 72.96757612377405
      },
      {
        "latitude": 19.655379639570143,
        "longitude": 72.96759489923716
      },
      {
        "latitude": 19.655373956240698,
        "longitude": 72.96763379126787
      },
      {
        "latitude": 19.65538469141837,
        "longitude": 72.96765826642513
      },
      {
        "latitude": 19.65543142100689,
        "longitude": 72.96767670661211
      },
      {
        "latitude": 19.65577810361013,
        "longitude": 72.96767268329859
      },
      {
        "latitude": 19.655821044208285,
        "longitude": 72.96765055507421
      },
      {
        "latitude": 19.65582862195971,
        "longitude": 72.96762440353632
      },
      {
        "latitude": 19.655818834030725,
        "longitude": 72.96759489923716
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
 /* void retrieveSavedPolygonData() async {
    updatedPoints.addAll(points);
    List<LatLng> savedPolygonData = await geoPrefs.getSavedNewPolygonData();
    savedPolygonData.forEach((element) {
      updatedPoints.add(element );
    });
    print("vghvghghvghjh"+updatedPoints.toString());

  }*/
 /* Future<List<LatLng>> retrieveSavedPolygonData() async {
    updatedPoints.addAll(points);

    List<LatLng> savedPolygonData = await geoPrefs.getSavedNewPolygonData();
    savedPolygonData.forEach((element) {
      updatedPoints.add(element);
    });

    print("Updated Points: $updatedPoints");

    return updatedPoints;
  }*/
  /*Future<void> initializePolygon() async {
    List<LatLng> savedPolygonData = await retrieveSavedPolygonData();
    points.addAll(savedPolygonData);

    _polygone.add(Polygon(
      polygonId: PolygonId('1'),
      points: points,
      fillColor: Colors.transparent,
      geodesic: true,
      strokeColor: Colors.red,
      strokeWidth: 50,
    ));

    print("lisisisis"+points.toString());
  }*/

/*  Future<List<LatLng>> retrieveSavedPolygonData() async {
    updatedPoints.addAll(points);

    Map<String, List<LatLng>> savedPolygonData = await geoPrefs.getSavedPolygonData();
   *//* savedPolygonData.forEach((element) {
      updatedPoints.add(element);
    });*//*
    savedPolygonData.forEach((key, value) {
      _polygone.add(Polygon(
        polygonId: PolygonId('1'),
        points: value,
        fillColor: Colors.transparent,
        geodesic: true,
        strokeColor: Colors.red,
        strokeWidth: 50,
      ));
    });

    print("Updated Points: $updatedPoints");

    return updatedPoints;
  }*/
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
