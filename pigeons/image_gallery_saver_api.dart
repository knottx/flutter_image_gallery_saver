import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: 'flutter_image_gallery_saver',
    dartOut: 'lib/src/image_gallery_saver_api.g.dart',
    kotlinOptions: KotlinOptions(
      package: 'dev.knottx.flutter_image_gallery_saver',
    ),
    kotlinOut:
        'android/src/main/kotlin/dev/knottx/flutter_image_gallery_saver/ImageGallerySaverApi.g.kt',
    swiftOut: 'ios/Classes/ImageGallerySaverApi.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
@HostApi()
abstract class ImageGallerySaverApi {
  @async
  void saveImage(Uint8List imageBytes);

  @async
  void saveFile(String filePath);
}
