import Foundation
import Combine
import MTBackEndCore
import MedicationContext

class DefaultDomainEvents: MedTrackerBackEndEvents {
    private var cancellables = Set<AnyCancellable>()

    private let newMedicationTrackedSubject = PassthroughSubject<NewMedicationTracked, Never>()
    var newMedicationTracked: AnyPublisher<NewMedicationTracked, Never> {
        newMedicationTrackedSubject.eraseToAnyPublisher()
    }

    private let administrationRecordedSubject = PassthroughSubject<AdministrationRecorded, Never>()
    var administrationRecorded: AnyPublisher<AdministrationRecorded, Never> {
        administrationRecordedSubject.eraseToAnyPublisher()
    }

    private let administrationRemovedSubject = PassthroughSubject<AdministrationRemoved, Never>()
    var administrationRemoved: AnyPublisher<AdministrationRemoved, Never> {
        administrationRemovedSubject.eraseToAnyPublisher()
    }

    init() {
        subscribeToNotifications()
    }

    private func subscribeToNotifications() {
        NotificationCenter.default
            .publisher(for: .newMedicationTracked, object: nil)
            .compactMap { $0.userInfo?["domainEvent"] as? NewMedicationTracked }
            .sink { [weak self] in self?.newMedicationTrackedSubject.send($0) }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: .administrationRecorded, object: nil)
            .compactMap { $0.userInfo?["domainEvent"] as? AdministrationRecorded }
            .sink { [weak self] in self?.administrationRecordedSubject.send($0) }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: .administrationRemoved, object: nil)
            .compactMap { $0.userInfo?["domainEvent"] as? AdministrationRemoved }
            .sink { [weak self] in self?.administrationRemovedSubject.send($0) }
            .store(in: &cancellables)
    }
}

extension Notification.Name {
    static let newMedicationTracked = Notification.Name("NewMedicationTracked")
    static let administrationRecorded = Notification.Name("AdministrationRecorded")
    static let administrationRemoved = Notification.Name("AdministrationRemoved")
}
