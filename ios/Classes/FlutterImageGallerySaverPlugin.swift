import Flutter
import UIKit

public class FlutterImageGallerySaverPlugin: NSObject, FlutterPlugin { 
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger = registrar.messenger()
    let apiImpl = ImageGallerySaverApiImpl()
    ImageGallerySaverApiSetup.setUp(binaryMessenger: messenger, api: apiImpl)
  }
}
