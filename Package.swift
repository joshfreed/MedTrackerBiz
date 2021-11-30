// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MedTrackerBiz",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "MedTrackerBiz",
            targets: ["Medication"]),
    ],
    dependencies: [
        .package(name: "JFLib", url: "https://github.com/joshfreed/JFLib", .branch("main"))
    ],
    targets: [
        .target(
            name: "Medication",
            dependencies: []),
        .testTarget(
            name: "MedicationTests",
            dependencies: ["Medication"]),
    ]
)
