import 'package:fav_places/models/place.dart';
import 'package:fav_places/provider/place_provider.dart';
import 'package:fav_places/screens/add_placescreen.dart';
import 'package:fav_places/screens/place_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePlaces extends ConsumerStatefulWidget {
  const FavoritePlaces({super.key});

  @override
  ConsumerState<FavoritePlaces> createState() => _FavoritePlacesState();
}

class _FavoritePlacesState extends ConsumerState<FavoritePlaces> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placeProvider.notifier).loadPlaces();
  }

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
  Widget build(BuildContext context) {
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
        itemBuilder: (ctx, index) {
          final place = allPlaces[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return PlaceDetails(place: place);
                  },
                ),
              );
            },
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: FileImage(place.image),
            ),
            title: Text(place.title),
            subtitle: FutureBuilder<String>(
              future: ref
                  .read(placeProvider.notifier)
                  .retrievingLocation(
                    placeId: place.id,
                    longitude: place.location.longitude,
                    latitude: place.location.latitude,
                  ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading address...');
                }
                if (snapshot.hasError) {
                  return const Text('Address unavailable');
                }
                return Text(snapshot.data ?? 'Address unavailable');
              },
            ),
          );
        },
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
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) {
          return content;
        },
      ),
    );
  }
}
