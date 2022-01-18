import Foundation

/// The current Xcode environment that the code is running in.
public enum XcodeEnvironment {
    /// The code is running in an app target on a simulator or device
    case live

    /// The code is running as part of UI Tests
    case test

    /// The code is running in a SwiftUI preview canvas
    case preview

    /// Autodetects the current Xcode environment
    public static func autodetect() -> XcodeEnvironment {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return .preview
        } else if ProcessInfo.processInfo.arguments.contains("UI_TESTING") {
            return .test
        } else {
            return .live
        }
    }
}
