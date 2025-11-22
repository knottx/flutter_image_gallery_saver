import 'dart:typed_data';

import 'package:flutter_image_gallery_saver/src/image_gallery_saver_api.g.dart';

class ImageGallerySaver {
  /// The instance of [ImageGallerySaverApi] used to communicate with the host platform.
  final ImageGallerySaverApi _api;

  /// Constructor for [ImageGallerySaver].  The optional [api] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// ImageGallerySaverApi will be used which routes to the host platform.
  ImageGallerySaver([ImageGallerySaverApi? api])
      : _api = api ?? ImageGallerySaverApi();

  /// Save image PNG,JPG,JPEG image located at [imageBytes] to gallery.
  Future<void> saveImage(Uint8List imageBytes) {
    return _api.saveImage(imageBytes);
  }

  /// Save file PNG,JPG,JPEG image or video located at [filePath] to gallery.
  Future<void> saveFile(String filePath) {
    return _api.saveFile(filePath);
  }
}
