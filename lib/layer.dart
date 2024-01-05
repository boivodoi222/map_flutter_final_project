import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:latlong2/latlong.dart';

class GeoServerService {
  static Future<List<LatLng>> fetchDataFromGeoServer() async {
    const String geoServerUrl =
        'http://localhost:8080/geoserver/B2/wms?service=WMS&version=1.1.0&request=GetMap&layers=B2%3ABTL&bbox=574320.4496641505%2C2326643.311940953%2C583431.0231157464%2C2334401.19173442&width=768&height=653&srs=EPSG%3A3405&styles=&format=application/openlayers';

    try {
      final response = await http.get(Uri.parse(geoServerUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Process data to extract coordinates and return List<LatLng>
        List<LatLng> coordinates = extractCoordinates(data);
        return coordinates;
      } else {
        throw Exception('Failed to load data from GeoServer');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static List<LatLng> extractCoordinates(Map<String, dynamic> data) {
    // Process data to extract coordinates and return List<LatLng>
    // Adjust this part based on the actual structure of the data returned by GeoServer
    // Example: data['features'][0]['geometry']['coordinates']
    
    // Dummy data for illustration
    List<LatLng> coordinates = [
      LatLng(21.0, 105.0),
      LatLng(22.0, 106.0),
      //...
    ];

    return coordinates;
  }
}
