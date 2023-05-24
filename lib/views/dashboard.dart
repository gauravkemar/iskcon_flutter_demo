import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskcon_flutter_demo/views/live_location.dart';
import 'package:iskcon_flutter_demo/views/location_map_screen.dart';
import 'package:iskcon_flutter_demo/views/new_loc_geolocator.dart';
import 'package:iskcon_flutter_demo/views/new_screen_loc_testing.dart';
import 'package:iskcon_flutter_demo/views/set_geofence.dart';
import 'package:iskcon_flutter_demo/views/using_stream_geolocator.dart';

import '../audioplayer.dart';
import '../bottomsheet/bottomsheetdemo.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ISKCON GEV GEOFENCE DEMO"),centerTitle: true),
      body: initScreen(context),
    );
  }

  route(int screen) {
    switch(screen) {
      case 1: {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LiveLocation()));
      }
      break;
      case 2: {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SetGeofence()));
      }
      break;
      case 3: {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LocationMapScreen()));
      }
      break;
      case 4: {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LiveLocNew()));
      }
      break;
      case 5: {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LiveLocStreamGeolocator()));
      }
      break;
      case 6: {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LiveLocUsingGetCurrentPost()));
      }
      break;
      case 7: {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AudioDemo()));
      }
      break;
    }
  }

  ElevatedButton button(String text,int btnMethod) {
    return ElevatedButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
            (Set<MaterialState> states) {
              return EdgeInsets.fromLTRB(30, 15, 30, 15);
            },
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
      onPressed: () async {
        route(btnMethod);
        showShortToast(text);
      },
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18.0)),
    );
  }

  initScreen(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Center(
      // heightFactor: 3,
      // widthFactor: 0.8,
      child: Container(
        width: queryData.size.width,
        height: queryData.size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button("Live Location Demo",1),
            const SizedBox(
              height: 20,
            ),
            button("Set Goefence",2),
            const SizedBox(
              height: 20,
            ),
            button("Location Map Screen",3),
            const SizedBox(
              height: 20,
            ),
            button("Live Loc New",4),
            const SizedBox(
              height: 20,
            ),
            button("Live Loc Stream based",5),
            const SizedBox(
              height: 20,
            ),
            button("loc getcurrentposition based",6),
            const SizedBox(
              height: 20,
            ),
            button("bottom Sheet",7),
          ],
        ),
      ),
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
