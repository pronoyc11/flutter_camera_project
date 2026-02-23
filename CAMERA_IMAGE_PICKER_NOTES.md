# Camera Image Picker Notes (Flutter)

This note summarizes how we fixed the camera issue in `fav_places` and how to debug it next time.

## Problem
Tapping the camera button did not open the camera.

## Root Cause Pattern
`image_picker` camera needs all of these:
1. Dart call uses `ImageSource.camera`.
2. Platform permissions are declared.
3. App is running on a supported target (Android/iOS device/emulator with camera support).
4. Native config changes are applied via full restart/reinstall (not only hot reload).

If any one is missing, camera may fail silently.

## Fixes Applied

### 1) Android permission
File: `android/app/src/main/AndroidManifest.xml`

Added:

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### 2) iOS permission descriptions
File: `ios/Runner/Info.plist`

Added:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take place photos.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to save and use place photos.</string>
```

### 3) Better runtime handling in widget
File: `lib/widgets/image_picker.dart`

What changed:
- Guard unsupported platforms (web/desktop) and show a clear snackbar.
- Wrap camera call in `try/catch`.
- Catch `PlatformException` for permission/plugin errors.
- Keep a fallback `catch` for unexpected errors.
- Save selected image to local state and show image preview.

## Why `mounted` checks were added
In async methods, the user might leave the screen before `await` finishes.

- `mounted == true`: widget is still in tree, safe to call `setState` and use `context`.
- `mounted == false`: widget disposed, unsafe to update UI.

Pattern used:

```dart
if (!mounted) return;
```

## Reusable Camera Debug Checklist
1. Verify Dart call:
   - `await ImagePicker().pickImage(source: ImageSource.camera)`
2. Verify Android manifest has `CAMERA` permission.
3. Verify iOS `Info.plist` has `NSCameraUsageDescription`.
4. Add `try/catch` and show snackbar/log error message.
5. Test on physical Android/iOS device (or properly configured emulator).
6. Fully stop app and rerun after native config edits.
7. If still failing, uninstall app and run again.

## Quick Template (Safe Pattern)

```dart
Future<void> pickAnImage() async {
  if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera is supported on Android/iOS only.')),
    );
    return;
  }

  try {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null || !mounted) return;

    setState(() {
      storedImage = File(picked.path);
    });
  } on PlatformException catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? e.code)),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open camera: $e')),
    );
  }
}
```

## Export to PDF
You can export this file directly:
1. Open `CAMERA_IMAGE_PICKER_NOTES.md` in VS Code.
2. Print (`Ctrl+P` in editor preview/markdown extension) and choose `Save as PDF`.
3. Or use any Markdown-to-PDF extension.
