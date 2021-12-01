// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MedTrackerBiz",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "MedTrackerBiz",
            targets: ["MedicationApp"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MedicationApp",
            dependencies: [],
            path: "Sources/Medication"),
        .testTarget(
            name: "MedicationTests",
            dependencies: ["MedicationApp"]),
    ]
)
