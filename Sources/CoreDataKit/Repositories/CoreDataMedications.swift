import Foundation
import CoreData
import MedicationContext

public class CoreDataMedications: MedicationRepository {
    private let context: NSManagedObjectContext

    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func add(_ medication: Medication) async throws {
        let entity = CDMedication(context: context)
        entity.fromDomainModel(medication)
    }

    public func getAll() async throws -> [Medication] {
        let request = CDMedication.fetchRequest()
        let result = try context.fetch(request)
        return try result.map { try $0.toDomainModel() }
    }

    public func getById(_ id: MedicationId) async throws -> Medication? {
        let request = CDMedication.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id.uuid as CVarArg)
        guard let entity = try context.fetch(request).first else {
            return nil
        }
        return try entity.toDomainModel()
    }

    public func save() async throws {
        try context.save()
    }
}
