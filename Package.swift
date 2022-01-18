// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MedTrackerBiz",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "MedTrackerCommon",
            targets: ["Common"]),
        .library(
            name: "MedTrackerBackEnd",
            targets: ["MedTrackerBackEnd"]),
        .library(
            name: "DefaultBackEnd",
            targets: ["DefaultBackEnd"]),
    ],
    dependencies: [
        .package(name: "JFLib", url: "https://github.com/joshfreed/JFLib", branch: "main")
    ],
    targets: [
        .target(
            name: "Common",
            dependencies: []),
        .target(
            name: "MedTrackerBackEnd",
            dependencies: ["MedicationApp"]),
        .target(
            name: "DefaultBackEnd",
            dependencies: [
                .product(name: "JFLib.Services", package: "JFLib"),
                "Common",
                "MedTrackerBackEnd",
                "MedicationApp",
                "CoreDataKit"
            ]),
        .target(
            name: "MedicationApp",
            dependencies: [
                .product(name: "JFLib.Date", package: "JFLib"),
                .product(name: "JFLib.DomainEvents", package: "JFLib"),
            ],
            path: "Sources/Medication"),
        .testTarget(
            name: "MedicationTests",
            dependencies: [
                "MedicationApp",
                .product(name: "JFLib.Testing", package: "JFLib")
            ]),
        .target(
            name: "CoreDataKit",
            dependencies: [
                "MedicationApp"
            ],
            resources: [.copy("MedTracker.xcdatamodeld")]),
        .testTarget(
            name: "CoreDataKitTests",
            dependencies: ["CoreDataKit"]),
    ]
)
