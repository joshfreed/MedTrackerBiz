import Foundation
import CoreData
import MedicationContext

public class CoreDataMedications: MedicationRepository {
    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func add(_ medication: Medication) async throws {
        await context.perform { [weak self] in
            guard let context = self?.context else { return }
            let entity = CDMedication(context: context)
            entity.fromDomainModel(medication)
        }
    }

    public func getAll() async throws -> [Medication] {
        let request = CDMedication.fetchRequest()
        return try await context.perform { [weak self] in
            try self?.context.fetch(request).map { try $0.toDomainModel() } ?? []
        }
    }

    public func getById(_ id: MedicationId) async throws -> Medication? {
        let request = CDMedication.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id.uuid as CVarArg)
        return try await context.perform { [weak self] in
            try self?.context.fetch(request).first?.toDomainModel()
        }
    }

    public func save() async throws {
        try await context.perform { [weak self] in
            try self?.context.save()
        }
    }

    public func update(_ medication: Medication) async throws {
        let request = CDMedication.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", medication.id.uuid as CVarArg)
        return try await context.perform { [weak self] in
            try self?.context.fetch(request).first?.fromDomainModel(medication)
        }
    }
}
