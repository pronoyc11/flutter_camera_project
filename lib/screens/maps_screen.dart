import 'package:fav_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key, this.place, this.currentLocation});

  final Place? place;
  final LatLng? currentLocation;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng? _selectedPoint;
  @override
  Widget build(BuildContext context) {
    final initialCenter =
        widget.currentLocation ?? widget.place?.location ?? const LatLng(24.0, 90.0);

    return FlutterMap(
        options: MapOptions(
          initialCenter: initialCenter,
          initialZoom: 15,
          onTap: (tapPosition, point) {
            setState(() {
              _selectedPoint = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: //"https://{s}.openstreetmap.org/{z}/{x}/{y}.png",
                'https://api.maptiler.com/maps/base-v4/256/{z}/{x}/{y}.png?key=0x2c1U4qCEAVNNtSCKcT',
            userAgentPackageName: "com.example.fav_places",
          ),
          MarkerLayer(
            markers: [
              if (_selectedPoint != null)
                Marker(
                  point: _selectedPoint!,
                  child: const Icon(
                    Icons.location_on_outlined,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
            

              if (widget.place != null)
                Marker(
                  point: widget.place!.location,
                  child: const Icon(
                    Icons.my_location_outlined,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              if (widget.currentLocation != null)
                Marker(
                  point: widget.currentLocation!,
                  child: const Icon(
                    Icons.my_location_outlined,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ],
      );
  }
}
