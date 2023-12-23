import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WebMap extends StatefulWidget {
  const WebMap({super.key});

  @override
  State<WebMap> createState() => _WebMapState();
}

class _WebMapState extends State<WebMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 64, 155, 240),
        title: const Text('Map Tutorial'),
      ),
      body: Center(
        child: FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(21.072204277457637, 105.77392294538035),
            initialZoom: 16.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              // Plenty of other options available!
            ),
          ],
        ),
      ),
    );
  }
}
