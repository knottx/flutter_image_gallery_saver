import Flutter
import UIKit
import Photos

class ImageGallerySaverApiImpl: ImageGallerySaverApi {
  func saveImage(imageBytes: FlutterStandardTypedData, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let image = UIImage(data: imageBytes.data) else {
      let error = self.makeError(
        code: "INVALID_ARGUMENTS", 
        message: "Invalid image bytes"
      )
      completion(.failure(error))
      return
    }
    saveUIImage(image, completion: completion)
  }

  func saveFile(filePath: String, completion: @escaping (Result<Void, Error>) -> Void) {
    if isImageFile(filePath), let image = UIImage(contentsOfFile: filePath) {
      saveUIImage(image, completion: completion)
    } else if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath) {
      let url = URL(fileURLWithPath: filePath)
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
      }) { success, error in
        if let error = error {
          let error = self.makeError(
            code: "SAVE_FAILED",
            message: error.localizedDescription
          )
          completion(.failure(error))
        } else if success {
          completion(.success(()))
        } else {
          let error = self.makeError(
            code: "SAVE_FAILED",
            message: "Unknown error while saving video file"
          )
          completion(.failure(error))
        }
      }
    } else {
      let error = self.makeError(code: "INVALID_FILE", message: "Invalid file")
      completion(.failure(error))
    }
  }
  
  private func isImageFile(_ filePath: String) -> Bool {
    let ext = (filePath as NSString).pathExtension.lowercased()
    let allowedExtensions: Set<String> = ["jpg", "jpeg", "png", "gif", "heic"]
    return allowedExtensions.contains(ext)
  }

  private func canSaveVideo(_ filePath: String) -> Bool {
        return UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath)
  }

  private func saveUIImage(_ image: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
    PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAsset(from: image)
    }) { success, error in
      if let err = error {
        let nsError = self.makeError(
          code: "SAVE_FAILED",
          message: err.localizedDescription 
        )
        completion(.failure(nsError))
      } else if success {
        completion(.success(()))
      } else {
        let nsError = self.makeError(
          code: "SAVE_FAILED",
          message: "Unknown error while saving image file"
        )
        completion(.failure(nsError))
      }
    }
  }

  private func makeError(code: String, message: String) -> NSError {
    return NSError(
      domain: "dev.knottx.flutter_image_gallery_saver",
      code: 1,
      userInfo: [
        "flutter_code": code,
        NSLocalizedDescriptionKey: message
      ]
    )
  }
}