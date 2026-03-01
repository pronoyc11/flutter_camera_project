import 'package:fav_places/screens/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key, required this.selectLocation});

  final void Function(LatLng) selectLocation;
  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final Location _location = Location();
  LatLng? _currentLocation;
  var isGettingLocation = false;

  Future<void> onSelectLocation() async {
    setState(() {
      isGettingLocation = true;
    });

    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          _showMessage('Please enable location service.');
          return;
        }
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
      }

      if (permissionGranted != PermissionStatus.granted) {
        _showMessage('Location permission is required.');
        return;
      }

      final LocationData locationData = await _location.getLocation();
      final double? longitude = locationData.longitude;
      final double? latitude = locationData.latitude;

      if (latitude == null || longitude == null) {
        _showMessage('Could not read your current location.');
        return;
      }
      // print(latitude);
      final LatLng liveLocation = LatLng(latitude, longitude);
      setState(() {
        _currentLocation = liveLocation;
      });
      widget.selectLocation(liveLocation);
    } catch (error) {
      _showMessage('Failed to fetch location. Please try again. $error');
    } finally {
      if (mounted) {
        setState(() {
          isGettingLocation = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 7)),
    );
  }
  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location selected yet.',
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    if (_currentLocation != null) {
      previewContent = MapsScreen(currentLocation: _currentLocation!);
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 170,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.40),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: onSelectLocation,
              label: const Text('Get your location'),
              icon: const Icon(Icons.location_on_outlined),
            ),
            TextButton.icon(
              onPressed: () => 0,
              label: const Text('Select on map.'),
              icon: const Icon(Icons.location_searching_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
