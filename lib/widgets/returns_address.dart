  // Future<String> _retrievingLocation(double long, double lat) async {
  //   try {
  //     final result = await MapTiler.geocodingAPI.searchByCoordinates(
  //       longitude: long,
  //       latitude: lat,
  //       // Keep reverse-geocode request minimal to avoid 400 on strict params.
  //       limit: 1,
  //       language: ['en'],
  //     );

  //     if (result.features.isEmpty) {
  //       _showMessage('No reverse-geocode result for these coordinates.');
  //       return "null";
  //     }

  //     return result.features[0].placeName!;

  //     // for (final feature in result.features) {
  //     //   debugPrint(
  //     //     'text=${feature.text}, placeName=${feature.placeName}, type=${feature.placeType}',
  //     //   );
  //     // }
  //   } catch (error) {
  //     debugPrint('Reverse geocode failed: $error');
  //     try {
  //       // Secondary probe: if this succeeds, key has geocoding enabled.
  //       final probe = await MapTiler.geocodingAPI.searchByName(
  //         'Dhaka',
  //         limit: 1,
  //       );
  //       for (final feature in probe.features) {
  //         debugPrint(
  //           'name-probe -> text=${feature.text}, placeName=${feature.placeName}, type=${feature.placeType}',
  //         );
  //       }
  //     } catch (fallbackError) {
  //       debugPrint('Geocoding probe failed: $fallbackError');
  //       _showMessage(
  //         'Geocoding request failed (400). Check API key scope/restrictions in MapTiler Cloud.',
  //       );
  //     }
  //     return "Correct value is not found";
  //   }
  // }