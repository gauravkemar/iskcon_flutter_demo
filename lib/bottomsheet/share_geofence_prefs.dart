import 'dart:async';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  Future<Map<String, List<LatLng>>> getSavedPolygonData() async {
    await initialize();
    String? encodedData = prefs!.getString("polygon");
    if (encodedData != null) {
      Map<String, dynamic> decodedData = jsonDecode(encodedData);
      Map<String, List<LatLng>> polygonData = {};
      decodedData.forEach((key, value) {
        if (value is List) {
          List<LatLng> latLngList = [];
          value.forEach((item) {
            if (item is List && item.length == 2) {
              double latitude = item[0] ?? 0.0;
              double longitude = item[1] ?? 0.0;
              latLngList.add(LatLng(latitude, longitude));
            }
          });
          polygonData[key] = latLngList;
        }
      });
      return polygonData;
    } else {
      print("No saved polygon data found");
    }
    return {}; // Return an empty map if there's no data found
  }
}
/*  Future<List<LatLng>> getSavedNewPolygonData() async {
    try {
      await initialize();
      if (prefs != null) {
        String? encodedData = prefs!.getString("polygon");
        if (encodedData != null) {
          Map<String, dynamic> decodedData = jsonDecode(encodedData);
          List<LatLng> polygonData = [];
          decodedData.forEach((key, value) {
            if (value is List) {
              value.forEach((item) {
                if (item is List && item.length == 2) {
                  double latitude = item[0] ?? 0.0;
                  double longitude = item[1] ?? 0.0;
                  LatLng latLng = LatLng(latitude, longitude);
                  polygonData.
                  add(latLng);
                }
              });
            }
          });
          return polygonData;
        } else {
          print("No saved polygon data found");
        }
      } else {
        print("SharedPreferences instance is null");
      }
    } catch (e) {
      print("Error retrieving saved polygon data: $e");
    }
    return []; // Return an empty list if there's an error or no data found
  }*/
 /* Future<List<LatLng>> getSavedNewPolygonData() async {
    try {
      await initialize();
      if (prefs != null) {
        String? encodedData = prefs!.getString("polygon");
        if (encodedData != null) {
          List<dynamic> decodedData = jsonDecode(encodedData);
          List<LatLng> polygonData = [];
          decodedData.forEach((item) {
            if (item is Map<String, dynamic>) {
              double latitude = item['latitude'] ?? 0.0;
              double longitude = item['longitude'] ?? 0.0;
              LatLng latLng = LatLng(latitude, longitude);
              polygonData.add(latLng);
            }
          });
          return polygonData;
        } else {
          print("No saved polygon data found");
        }
      } else {
        print("SharedPreferences instance is null");
      }
    } catch (e) {
      print("Error retrieving saved polygon data: $e");
    }
    return []; // Return an empty list if there's an error or no data found
  }*/

 /* Future<Map<String, List<LatLng>>> getSavedPolygonData() async {
    try {
      await initialize();
      if (prefs != null) {
        String? encodedData = prefs!.getString("polygon");
        if (encodedData != null) {
          Map<String, dynamic> decodedData = jsonDecode(encodedData);
          Map<String, List<LatLng>> polygonData = {};
          decodedData.forEach((key, value) {
            if (value is List) {
              List<LatLng> latLngList = [];
              value.forEach((item) {
                if (item is Map<String, dynamic>) {
                  double latitude = item['latitude'] ?? 0.0;
                  double longitude = item['longitude'] ?? 0.0;
                  latLngList.add(LatLng(latitude, longitude));
                }
              });
              polygonData[key] = latLngList;
            }
          });
          return polygonData;
        } else {
          print("No saved polygon data found");
        }
      } else {
        print("SharedPreferences instance is null");
      }
    } catch (e) {
      print("Error retrieving saved polygon data: $e");
    }
    return {}; // Return an empty map if there's an error or no data found
  }*/

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