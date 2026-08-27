import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {

  final double startLat;
  final double startLng;

  final double endLat;
  final double endLng;

  const MapScreen({
    super.key,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
  });

  @override
  Widget build(BuildContext context) {

    final points = [

      LatLng(startLat, startLng),

      LatLng(endLat, endLng),
    ];

    return Scaffold(

      appBar: AppBar(
        title: const Text('Route Map'),
      ),

      body: FlutterMap(

        options: MapOptions(

          initialCenter:
              LatLng(startLat, startLng),

          initialZoom: 11,
        ),

        children: [

          TileLayer(

            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

            userAgentPackageName:
                'com.example.smart_optimizer',
          ),

          PolylineLayer(

            polylines: [

              Polyline(

                points: points,

                strokeWidth: 5,

                color: Colors.deepPurpleAccent,
              ),
            ],
          ),

          MarkerLayer(

            markers: [

              Marker(

                point:
                    LatLng(startLat, startLng),

                width: 80,

                height: 80,

                child: const Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 40,
                ),
              ),

              Marker(

                point:
                    LatLng(endLat, endLng),

                width: 80,

                height: 80,

                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}