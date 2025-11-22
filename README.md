# Flutter Image Gallery Saver

Flutter Image Gallery Saver is a Flutter plugin that provides a simple API for saving images and files (e.g., PNG, JPG, JPEG, GIF, HEIC, videos) to the device gallery. The plugin uses platform channels to communicate with native code on Android and iOS to perform the saving operations.

## Features

- **Save Image:** Save image bytes (as `Uint8List`) directly to the gallery.
- **Save File:** Save a file (image or video) from a given file path to the gallery.

## Platform Setup

### Android

No additional configuration is usually required. However, ensure that your app has the necessary permissions to write to external storage. The plugin handles most permissions, but you may need to adjust your AndroidManifest.xml for Android 7.0 and above if you encounter any issues.

### iOS

Add the following key to your Info.plist to allow the plugin to save images to the photo library:

```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app requires access to your photo library to save images.</string>
```

## How to Use

### Import the Package

```dart
import 'dart:typed_data';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';

final imageSaver = ImageGallerySaver();

Future<void> saveImageExample(Uint8List imageBytes) async {
  try {
    await imageSaver.saveImage(imageBytes);
    print('Image saved successfully!');
  } catch (e) {
    print('Error saving image: $e');
  }
}

Future<void> saveFileExample(String filePath) async {
  try {
    await imageSaver.saveFile(filePath);
    print('File saved successfully!');
  } catch (e) {
    print('Error saving file: $e');
  }
}
```
