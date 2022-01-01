// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MedTrackerBiz",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "MedicationApp",
            targets: ["MedicationApp"]),
        .library(
            name: "CoreDataKit",
            targets: ["CoreDataKit"]),
    ],
    dependencies: [
        .package(name: "JFLib", url: "https://github.com/joshfreed/JFLib", branch: "main")
    ],
    targets: [
        .target(
            name: "MedicationApp",
            dependencies: [
                .product(name: "JFLib.Date", package: "JFLib"),
                .product(name: "JFLib.DomainEvents", package: "JFLib"),
            ],
            path: "Sources/Medication"),
        .target(
            name: "CoreDataKit",
            dependencies: [
                "MedicationApp"
            ],
            resources: [.copy("MedTracker.xcdatamodeld")]),
        .testTarget(
            name: "MedicationTests",
            dependencies: [
                "MedicationApp",
                .product(name: "JFLib.Testing", package: "JFLib")
            ]),
        .testTarget(
            name: "CoreDataKitTests",
            dependencies: ["CoreDataKit"]),
    ]
)
