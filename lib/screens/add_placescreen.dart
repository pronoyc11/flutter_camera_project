import 'dart:io';

import 'package:fav_places/models/place.dart';
import 'package:fav_places/provider/place_provider.dart';
import 'package:fav_places/widgets/image_picker.dart';
import 'package:fav_places/widgets/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class AddPlacescreen extends ConsumerStatefulWidget {
  const AddPlacescreen({super.key});

  @override
  ConsumerState<AddPlacescreen> createState() => _AddPlacescreenState();
}

class _AddPlacescreenState extends ConsumerState<AddPlacescreen> {
  final _titleController = TextEditingController();
  File? finalSelectedImage;
  LatLng? location;

  void setLocation(LatLng l) {
    setState(() {
      location = l;
    });
  }

  void onFormSave() {
    final enteredText = _titleController.text;

    if (enteredText.trim().length < 2 ||
        finalSelectedImage == null ||
        location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please provide a valid title, image, and location.",
          ),
        ),
      );
      return;
    }

    ref.read(placeProvider.notifier).addPlace(
      Place(title: enteredText.trim(), image: finalSelectedImage!, location: location!),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new place")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 15,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: const InputDecoration(
                label: Text("Place Name"),
                icon: Icon(Icons.place),
              ),
            ),
            const SizedBox(height: 16),

            ImagePickerr(
              onSelectImage: (File img) {
                finalSelectedImage = img;
              },
            ),
            const SizedBox(height: 16),

            //Add Location
            LocationPicker(selectLocation:setLocation),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _titleController.clear();
                    setState(() {
                      finalSelectedImage = null;
                      location = null;
                    });
                  },
                  child: const Text("Reset"),
                ),
                ElevatedButton(
                  onPressed: onFormSave,
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
