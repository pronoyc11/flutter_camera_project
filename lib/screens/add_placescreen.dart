import 'package:fav_places/models/place.dart';
import 'package:fav_places/provider/place_provider.dart';
import 'package:fav_places/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlacescreen extends ConsumerStatefulWidget {
  const AddPlacescreen({super.key});

  @override
  ConsumerState<AddPlacescreen> createState() => _AddPlacescreenState();
}

class _AddPlacescreenState extends ConsumerState<AddPlacescreen> {
  final _titleController = TextEditingController();

  void onFormSave() {
    final enteredText = _titleController.text;

    if (enteredText.trim().length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please provide a valid name with more than two characters!"),
        ),
      );
      return;
    }

    ref.read(placeProvider.notifier).addPlace(Place(title: enteredText));
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
          const SizedBox(height: 16,),

          ImagePickerr(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _titleController.clear(),
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
