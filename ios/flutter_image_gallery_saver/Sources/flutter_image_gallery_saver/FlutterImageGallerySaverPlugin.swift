import Flutter
import UIKit

public class FlutterImageGallerySaverPlugin: NSObject, FlutterPlugin { 
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger = registrar.messenger()
    let api = ImageGallerySaverApiImpl()
    ImageGallerySaverApiSetup.setUp(binaryMessenger: messenger, api: api)
  }
}
