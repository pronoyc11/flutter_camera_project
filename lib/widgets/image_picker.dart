import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerr extends StatefulWidget {
  const ImagePickerr({super.key,required this.onSelectImage});

final void Function(File) onSelectImage; 
  @override
  State<ImagePickerr> createState() => _ImagePickerrState();
}

class _ImagePickerrState extends State<ImagePickerr> {
  File? storedImage;
  Future<void> pickAnImage() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Camera is only supported for android or ios platform!",
          ),
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
      if (!mounted || pickedImage == null) {
        return;
      }
      setState(() {
        storedImage = File(pickedImage.path);
      });
      widget.onSelectImage(storedImage!);
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Platform permission : ${error.message}, ${error.code}",
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open camera: $error')));
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
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }
    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.40),
        ),
      ),
      child: content,
    );
  }
}
