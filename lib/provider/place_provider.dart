import 'dart:io';

import 'package:fav_places/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart';
import 'package:maptiler_flutter/maptiler_flutter.dart';
import 'package:path_provider/path_provider.dart' as sys_path;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);
  final Map<String, String> _addressCache = {};

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final userPlaces = await db.query('user_places');

    final places = userPlaces.map((row) {
      return Place(
        id: row['id'] as String,
        title: row['title'] as String,
        image: File(row['image'] as String),
        location: LatLng(row['lat'] as double, row['long'] as double),
      );
    }).toList();

    state = places;
  }

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,long REAL,address TEXT)",
        );
      },
      version: 1,
    );
    return db;
  }

  void addPlace(Place p) async {
    final appDir = await sys_path.getApplicationDocumentsDirectory();
    final fileName = path.basename(p.image.path);
    final copiedImage = await p.image.copy('${appDir.path}/$fileName');
    Place newP = Place(
      title: p.title,
      image: copiedImage,
      location: p.location,
    );

    final address = await retrievingLocation(
      placeId: newP.id,
      longitude: newP.location.longitude,
      latitude: newP.location.latitude,
    );

    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newP.id,
      'title': newP.title,
      'image': newP.image.path,
      'lat': newP.location.latitude,
      'long': newP.location.longitude,
      'address': address,
    });
    state = [...state, newP];
  }

  void removePlace(String id) {
    state = state.where((element) => element.id != id).toList();
    _addressCache.remove(id);
  }

  Future<String> retrievingLocation({
    required String placeId,
    required double longitude,
    required double latitude,
  }) async {
    final cached = _addressCache[placeId];
    if (cached != null) return cached;

    try {
      final result = await MapTiler.geocodingAPI.searchByCoordinates(
        longitude: longitude,
        latitude: latitude,
        limit: 1,
        language: ['en'],
      );

      if (result.features.isEmpty) {
        return 'Unknown location';
      }

      final address =
          result.features.first.placeName ?? result.features.first.text;
      _addressCache[placeId] = address;
      return address;
    } catch (error) {
      return 'Address unavailable';
    }
  }
}

final placeProvider = StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
