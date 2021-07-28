// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Guppy",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Guppy", targets: ["Guppy"])
    ],
    targets: [
        .target(name: "Guppy", path: "Sources", exclude: ["Supporting Files/Info.plist"])
    ]
)
