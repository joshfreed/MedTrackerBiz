import Foundation
import Dip

public protocol MedTrackerModule {
    func registerServices(env: XcodeEnvironment, container: DependencyContainer)
    func bootstrap(env: XcodeEnvironment)
}

extension MedTrackerModule {
    func registerServices(env: XcodeEnvironment, container: DependencyContainer) {}
    func bootstrap(env: XcodeEnvironment) {}
}
