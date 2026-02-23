import 'package:fav_places/models/place.dart';
import 'package:fav_places/provider/place_provider.dart';
import 'package:fav_places/screens/add_placescreen.dart';
import 'package:fav_places/screens/place_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePlaces extends ConsumerWidget {
  const FavoritePlaces({super.key});

  void navigateToAdd(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return AddPlacescreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Place> allPlaces = ref.watch(placeProvider);

    Widget content = Center(
      child: Text(
        "No places added yet!",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );

    if (allPlaces.isNotEmpty) {
      content = ListView.builder(
        itemCount: allPlaces.length,
        itemBuilder: (ctx, index) => ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) {
                  return PlaceDetails(place: allPlaces[index]);
                },
              ),
            );
          },
          title: Text(allPlaces[index].title),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My favorite places"),
        actions: [
          TextButton(
            onPressed: () => navigateToAdd(context),
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}
