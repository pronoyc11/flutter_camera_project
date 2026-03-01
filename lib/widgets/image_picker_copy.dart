import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerr extends StatefulWidget {
  const ImagePickerr({super.key});

  @override
  State<ImagePickerr> createState() => _ImagePickerrState();
}

class _ImagePickerrState extends State<ImagePickerr> {
  File? storedImage;

  Future<void> pickAnImage() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera capture is supported on Android and iOS devices only.'),
        ),
      );
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
        imageQuality: 85,
      );

      if (pickedImage == null || !mounted) {
        return;
      }

      setState(() {
        storedImage = File(pickedImage.path);
      });
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera permission/error: ${error.message ?? error.code}'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open camera: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: pickAnImage,
      label: const Text('Take picture'),
      icon: Icon(
        Icons.camera_alt,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );

    if (storedImage != null) {
      content = GestureDetector(
        onTap: pickAnImage,
        child: Image.file(
          storedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.40),
        ),
      ),
      child: content,
    );
  }
}
