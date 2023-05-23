import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeoPrefs {
  static SharedPreferences? prefs;


  static Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }
  Future<void> savePolygonData(Map<String, List<LatLng>> polygonData) async {
    try {
      await initialize();
      if (prefs != null) {
        String encodedData = jsonEncode(polygonData);
        prefs!.setString("polygon", encodedData);
        print("Successfully saved polygon data");
      } else {
        print("SharedPreferences instance is null");
      }
    } catch (e) {
      print("Error saving polygon data: $e");
    }
  }
}
/*  void savePolygonData(Map<String, List<LatLng>> polygonData){
    //if (_prefs != null) {
      initialize();
      if(prefs!=null)
        {
          String encodedData = jsonEncode(polygonData);
          prefs!.setString("polygon", encodedData);
        }
      else
        {
          print("nosucessinprefs");
        }

  //  }
  }
  }*/
















   /* data.forEach((key, value) {
      List<dynamic> coordinates = value['zza'];
      List<LatLng> polygonPoints = coordinates.map((c) {
        return LatLng(c['latitude'], c['longitude']);
      }).toList();
      polygonData[key] = polygonPoints;
    });
*/



/*  void savePolygonData(Map<String, List<LatLng>> polygonData) {
    if (_prefs != null) {
      Map<String, dynamic> data = {};

      polygonData.forEach((key, value) {
        List<Map<String, double>> coordinates = value.map((LatLng point) {
          return {'latitude': point.latitude, 'longitude': point.longitude};
        }).toList();
        data[key] = {
          'zza': coordinates,
        };
      });

       String encodedData = jsonEncode(data);
      _prefs!.setString("Polygon", encodedData);
    }
  }*/




/*// Function to save the polygon data to shared preferences
  Future<void> savePolygonDataToSharedPreferences(Map<String, dynamic> polygonData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the polygon data to JSON
    String jsonData = json.encode(polygonData);

    // Save the JSON data to shared preferences
    await prefs.setString('polygonDataKey', jsonData);
  }

// Function to retrieve the polygon data from shared preferences
  Future<Map<String, dynamic>> getPolygonDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON data from shared preferences
    String? jsonData = prefs.getString('polygonDataKey');

    // Parse the JSON data
    Map<String, dynamic> polygonData = json.decode(jsonData!);

    return polygonData;
  }

// Example usage
  void saveAndRetrievePolygonData() async {
    Map<String, dynamic> polygonData = await getPolygonData(); // Assuming getPolygonData() is defined

    // Save the polygon data to shared preferences
    await savePolygonDataToSharedPreferences(polygonData);

    // Retrieve the polygon data from shared preferences
    Map<String, dynamic> retrievedPolygonData = await getPolygonDataFromSharedPreferences();

    print(retrievedPolygonData);
  }*/



/*  Future<void> savePolygonData(Map<String, List<LatLng>> polygonData) async {
    if (_prefs != null) {
      String encodedData = jsonEncode(polygonData);
      await _prefs!.setString(Constants.POLYGON, encodedData);
    }
  }*/

/*  Map<String, List<LatLng>>? getPolygonData() {
    if (_prefs != null) {
      String? encodedData = _prefs!.getString(Constants.POLYGON);
      if (encodedData != null) {
        return jsonDecode(encodedData);
      }
    }
    return null;
  }*/