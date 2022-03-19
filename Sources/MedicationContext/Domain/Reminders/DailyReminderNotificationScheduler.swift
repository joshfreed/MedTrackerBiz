import Foundation

public class DailyReminderNotificationScheduler {
    private let notificationService: NotificationService
    private let medicationRepository: MedicationRepository
    private let administrationRepository: AdministrationRepository

    private let maxNotificationCount = 10

    public init(notificationService: NotificationService, medicationRepository: MedicationRepository, administrationRepository: AdministrationRepository) {
        self.notificationService = notificationService
        self.medicationRepository = medicationRepository
        self.administrationRepository = administrationRepository
    }

    func scheduleNotifications() async throws {
        try await notificationService.removeAll()

        let medications = try await medicationRepository.getAll()
        for medication in medications {
            try await scheduleNotifications(for: medication, startingOn: Date.current)
        }
    }

    func scheduleNotifications(for medicationId: String, startingOn date: Date) async throws {
        guard let medicationId = MedicationId(uuidString: medicationId) else {
            throw SchedulingError.invalidMedicationId
        }

        try await cancelPendingNotifications(for: medicationId)

        guard let medication = try await medicationRepository.getById(medicationId) else {
            throw SchedulingError.medicationNotFound
        }

        try await scheduleNotifications(for: medication, startingOn: date)
    }

    private func cancelPendingNotifications(for medicationId: MedicationId) async throws {
        var notificationIds: [String] = []

        for i in 0..<maxNotificationCount {
            let id = "\(medicationId)_\(i)"
            notificationIds.append(id)
        }

        try await notificationService.remove(notificationsMatchingIds: notificationIds)
    }

    private func scheduleNotifications(for medication: Medication, startingOn date: Date) async throws {
        guard medication.reminder != nil else {
            return
        }

        let wasAdministeredToday = try await administrationRepository.hasAdministration(on: date, for: medication.id)

        let notifications = try medication.scheduleReminderNotifications(wasAdministered: wasAdministeredToday)

        try await notificationService.add(notifications: notifications)
    }
}

extension DailyReminderNotificationScheduler {
    enum SchedulingError: Error {
        case invalidMedicationId
        case medicationNotFound
    }
}
