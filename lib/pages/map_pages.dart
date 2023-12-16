import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as LatLng;


class AppMap extends StatefulWidget {
  const AppMap({super.key});

  @override
  State<AppMap> createState() => _AppMapState();
}

class _AppMapState extends State<AppMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // check new text
        title: Text('Flutter Map Tutorial - Kabalidev'),
      ),
      body: SafeArea(
          child: Container(
        child: Stack(children: [
          Positioned(
            child: widget.isLoad
                ? FlutterMap(
                    //we have to add mapcontroller to flutter map
                    mapController: _mapController,
                    options: MapOptions(
                        center: LatLng.LatLng(widget.position.latitude,
                            widget.position.longitude),
                        zoom: 13.0,
                        plugins: [
                          LocationMarkerPlugin(),
                          MarkerClusterPlugin()
                        ]),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayerOptions(markers: [
                        Marker(
                            width: 100,
                            height: 100,
                            point: new LatLng.LatLng(widget.position.latitude,
                                widget.position.longitude),
                            builder: (context) => new Icon(
                                  Icons.pin_drop,
                                  color: Colors.red,
                                ))
                      ]
                          // setMarkers(),
                          ),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
