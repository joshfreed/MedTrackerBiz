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

    func scheduleNotifications(for medicationId: String, startingOn date: Date) async throws {
        guard let medicationId = MedicationId(uuidString: medicationId) else {
            throw SchedulingError.invalidMedicationId
        }

        cancelPendingNotifications(for: medicationId)

        guard let medication = try await medicationRepository.getById(medicationId) else {
            throw SchedulingError.medicationNotFound
        }

        guard medication.reminder != nil else {
            return
        }

        let wasAdministeredToday = try await administrationRepository.hasAdministration(on: date, for: medicationId)

        let notifications = try medication.scheduleReminderNotifications(wasAdministered: wasAdministeredToday)

        try await notificationService.add(notifications: notifications)
    }

    func cancelPendingNotifications(for medicationId: MedicationId) {
        var notificationIds: [String] = []

        for i in 0..<maxNotificationCount {
            let id = "\(medicationId)_\(i)"
            notificationIds.append(id)
        }

        notificationService.remove(notificationsMatchingIds: notificationIds)
    }
}

extension DailyReminderNotificationScheduler {
    enum SchedulingError: Error {
        case invalidMedicationId
        case medicationNotFound
    }
}
