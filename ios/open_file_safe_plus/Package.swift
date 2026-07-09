// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "open_file_safe_plus",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "open-file-safe-plus", targets: ["open_file_safe_plus"])
    ],
    targets: [
        .target(
            name: "open_file_safe_plus",
            dependencies: [],
            cSettings: [
                .headerSearchPath("include/open_file_safe_plus")
            ]
        )
    ]
)
