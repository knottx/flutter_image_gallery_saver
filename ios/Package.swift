// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "flutter_image_gallery_saver",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "flutter_image_gallery_saver",
            targets: ["flutter_image_gallery_saver"]
        )
    ],
    targets: [
        .target(
            name: "flutter_image_gallery_saver",
            path: "Classes"
        )
    ]
)