import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iskcon_flutter_demo/views/live_location.dart';
import 'package:iskcon_flutter_demo/views/location_map_screen.dart';
import 'package:iskcon_flutter_demo/views/map_sample.dart';
import 'package:iskcon_flutter_demo/views/set_geofence.dart';

import 'views/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white, /* set Status bar color in Android devices. */
        statusBarIconBrightness: Brightness.dark,/* set Status bar icons color in Android devices.*/
        statusBarBrightness: Brightness.dark/* set Status bar icon color in iOS. */
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ISKCON GEV GEOFENCE DEMO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      /*home: const MyHomePage(title: 'ISKCON GEV GEOFENCE DEMO'),*/
      routes: {
        '/': (context) => Dashboard(),
        '/live_location': (context) => LiveLocation(),
        '/set_geofence': (context) => SetGeofence(),
        '/location_map_screen': (context) => LocationMapScreen(),
        '/map_sample': (context) => MapSample(),
      },
    );
  }
}
