import Foundation
import CoreData
import MedicationContext

public class CoreDataMedications: MedicationRepository {
    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func add(_ medication: Medication) throws {
        let entity = CDMedication(context: context)
        entity.fromDomainModel(medication)
    }

    public func getAll() throws -> [Medication] {
        let request = CDMedication.fetchRequest()
        let result = try context.fetch(request)
        return try result.map { try $0.toDomainModel() }
    }

    public func getById(_ id: MedicationId) throws -> Medication? {
        guard let entity = try fetchOneById(id) else { return nil }
        return try entity.toDomainModel()
    }

    public func save() throws {
        try context.save()
    }

    public func update(_ medication: Medication) throws {
        guard let entity = try fetchOneById(medication.id) else { return }
        entity.fromDomainModel(medication)
    }
}

// MARK: - Core Data Actions

extension CoreDataMedications {
    func fetchOneById(_ id: MedicationId) throws -> CDMedication? {
        let request = CDMedication.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id.uuid as CVarArg)
        return try context.fetch(request).first
    }
}
