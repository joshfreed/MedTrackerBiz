// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MedTrackerBiz",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "MedTrackerCommon",
            targets: ["MTCommon"]),
        .library(
            name: "MedTrackerBackEndCore",
            targets: ["MTBackEndCore"]),
        .library(
            name: "MedTrackerDefaultBackEnd",
            targets: ["MTDefaultBackEnd"]),
        .library(
            name: "MedTrackerModules",
            targets: ["MTLocalNotifications", "MTWidgetCenter"])
    ],
    dependencies: [
        .package(name: "JFLib", url: "https://github.com/joshfreed/JFLib", branch: "main")
    ],
    targets: [
        .target(
            name: "MTCommon",
            dependencies: [
                .product(name: "JFLib.Services", package: "JFLib"),
            ],
            path: "Sources/Common"),
        .target(
            name: "MTBackEndCore",
            dependencies: ["MedicationContext"],
            path: "Sources/BackEndCore"),
        .target(
            name: "MTDefaultBackEnd",
            dependencies: [
                .product(name: "JFLib.Services", package: "JFLib"),
                "MTCommon",
                "MTBackEndCore",
                "MedicationContext",
                "CoreDataKit"
            ],
            path: "Sources/DefaultBackEnd"),
        .target(
            name: "MedicationContext",
            dependencies: [
                .product(name: "JFLib.Date", package: "JFLib"),
                .product(name: "JFLib.DomainEvents", package: "JFLib"),
            ]),
        .testTarget(
            name: "MedicationContextTests",
            dependencies: [
                "MedicationContext",
                .product(name: "JFLib.Testing", package: "JFLib")
            ]),
        .target(
            name: "CoreDataKit",
            dependencies: [
                "MedicationContext"
            ],
            resources: [.copy("MedTracker.xcdatamodeld")]),
        .testTarget(
            name: "CoreDataKitTests",
            dependencies: ["CoreDataKit"]),

        .target(
            name: "MTLocalNotifications",
            dependencies: ["MTCommon"],
            path: "Sources/LocalNotifications"),

        .target(
            name: "MTWidgetCenter",
            dependencies: ["MTCommon"],
            path: "Sources/WidgetCenter"),

    ]
)
