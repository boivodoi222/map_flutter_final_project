import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class AppMap extends StatefulWidget {
  const AppMap({Key? key}) : super(key: key);

  @override
  State<AppMap> createState() => _AppMapState();
}

class _AppMapState extends State<AppMap> {
  late MapController mapController;
  var location =[];
  LatLng defaultLocation = LatLng(21.072204277457637, 105.77392294538035);
  LatLng? currentLocation;
  bool showAdditionalLayer = false;
  int tapCounter = 0;
  List<Marker> markers = [];
  LatLng? point;

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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          hintText: "Search for your location",
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    onTap: (tapPosition, point) {
                      _handleTap(point);
                    },
                    center: defaultLocation,
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (currentLocation != null)
                      MarkerLayer(markers: [
                        Marker(
                          point: currentLocation!,
                          child: IconButton(
                            icon: Icon(Icons.location_on),
                            color: Colors.red,
                            iconSize: 30.0,
                            onPressed: () {
                              _showLocationNameDialog(
                                context,
                                "Current Location",
                              );
                            },
                          ),
                        ),
                      ]),
                    if (showAdditionalLayer)
                      MarkerLayer(markers: markers),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${location.isNotEmpty ? location.first.addressLine : ''}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              tapCounter++;
              if (tapCounter % 2 == 1) {
                try {
                  Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );
                  setState(() {
                    currentLocation =
                        LatLng(position.latitude, position.longitude);
                    mapController.move(currentLocation!, 13.0);
                  });
                } catch (e) {
                  print('Error getting current location: $e');
                }
              } else {
                setState(() {
                  currentLocation = null;
                });
              }
            },
            tooltip: 'Toggle Geolocation',
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                showAdditionalLayer = !showAdditionalLayer;
              });
            },
            tooltip: 'Toggle Additional Layer',
            child: Icon(
              showAdditionalLayer ? Icons.layers_clear : Icons.layers,
            ),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              _addMarker();
            },
            tooltip: 'Add Marker',
            child: Icon(Icons.add_location),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                markers.clear();
              });
            },
            tooltip: 'Clear Markers',
            child: Icon(Icons.clear),
          ),
        ],
      ),
    );
  }

  void _addMarker() {
    if (point != null) {
      setState(() {
        markers.add(
          Marker(
            point: point!,
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: Colors.blue,
              iconSize: 30.0,
              onPressed: () {
                _showLocationNameDialog(context, "Custom Location");
              },
            ),
          ),
        );
      });
    }
  }

  Future<void> _showLocationNameDialog(
    BuildContext context,
    String locationName,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Name'),
          content: Text(locationName),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleTap(LatLng tappedPoint) async {

    setState(() {
      point = tappedPoint;
    });
  }
}
