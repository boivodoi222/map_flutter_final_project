import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'location.dart';

class AppMap extends StatefulWidget {
  const AppMap({Key? key}) : super(key: key);

  @override
  State<AppMap> createState() => _AppMapState();
}

class _AppMapState extends State<AppMap> {
  late MapController mapController;
  LatLng defaultLocation = LatLng(21.072204277457637, 105.77392294538035);
  LatLng? currentLocation;
  bool showAdditionalLayer = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 155, 240),
        title: const Text('Map Tutorial'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Flexible(
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: defaultLocation,
                    zoom: 16.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (currentLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: currentLocation!,
                            child: IconButton(
                              icon: Icon(Icons.location_on),
                              color: Colors.red,
                              iconSize: 30.0,
                              onPressed: () {
                                print('Marker tapped!');
                              },
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            Position position = await LocationService.determinePosition();
            setState(() {
              currentLocation = LatLng(position.latitude, position.longitude);
              mapController.move(currentLocation!, 16.0);
            });
          } catch (e) {
            print('Error getting current location: $e');
          }
        },
        tooltip: 'Get Current Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}


