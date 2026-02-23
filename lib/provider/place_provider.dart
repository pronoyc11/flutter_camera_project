import 'package:fav_places/models/place.dart';
import 'package:flutter_riverpod/legacy.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  void addPlace(Place p) {
    state = [...state, p];
  }

  void removePlace(int id) {
    state = state.where((element) => element.id != id).toList();
  }
}

final placeProvider = StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
