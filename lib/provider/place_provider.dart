import 'package:fav_places/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:maptiler_flutter/maptiler_flutter.dart';
import 'package:path_provider/path_provider.dart' as sys_path;
import 'package:path/path.dart' as path;




class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);
  final Map<String, String> _addressCache = {};

  void addPlace(Place p) async {
    final appDir = await sys_path.getApplicationDocumentsDirectory();
    final fileName = path.basename(p.image.path);
    final copiedImage = await p.image.copy('${appDir.path}/$fileName');
    Place newP = Place(
      title: p.title,
      image: copiedImage,
      location: p.location,
    );

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
