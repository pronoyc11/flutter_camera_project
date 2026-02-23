import 'package:fav_places/models/place.dart';
import 'package:flutter/material.dart';

class PlaceDetails extends StatelessWidget {
  const PlaceDetails({super.key, required this.place});

  final Place place;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Details of ${place.title}')));
  }
}
