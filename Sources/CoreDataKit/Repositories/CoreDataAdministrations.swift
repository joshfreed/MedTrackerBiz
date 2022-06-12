import Foundation
import CoreData
import MedicationContext

public class CoreDataAdministrations: AdministrationRepository {
    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func add(_ administration: Administration) async throws {
        await context.perform { [weak self] in
            guard let context = self?.context else { return }
            let entity = CDAdministration(context: context)
            entity.fromDomainModel(administration)
        }
    }

    public func findBy(medicationId: MedicationId, and date: Date) async throws -> Administration? {
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)

        let request = CDAdministration.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "medicationId = %@ AND (administrationDate >= %@) AND (administrationDate < %@)",
            medicationId.uuid as CVarArg,
            startDate as CVarArg,
            endDate! as CVarArg
        )

        return try await context.perform { [weak self] in
            try self?.context.fetch(request).first?.toDomainModel()
        }
    }

    public func hasAdministration(on date: Date, for medicationId: MedicationId) async throws -> Bool {
        (try await findBy(medicationId: medicationId, and: date)) != nil
    }

    public func remove(_ administration: Administration) async throws {
        let request = CDAdministration.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", administration.id.uuid as CVarArg)

        try await context.perform { [weak self] in
            guard let managedObject = try self?.context.fetch(request).first else { return }
            self?.context.delete(managedObject)
        }
    }

    public func save() async throws {
        try await context.perform { [weak self] in
            try self?.context.save()
        }
    }
}
