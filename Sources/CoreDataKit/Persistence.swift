import CoreData

public struct PersistenceController {
    public static let shared = PersistenceController()

    public static var testing: PersistenceController = {
        PersistenceController(inMemory: true)
    }()

    public let container: NSPersistentContainer

    public init(inMemory: Bool = false) {
        guard let modelURL = Bundle.module.url(forResource: "MedTracker", withExtension: "momd") else {
            fatalError("Couldn't find MedTracker.momd")
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Couldn't find NSManagedObjectModel at \(modelURL)")
        }

        container = NSPersistentContainer(name: "MedTracker", managedObjectModel: model)

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            let storeURL = URL.storeURL(for: "group.medtracker.core.data", databaseName: "MedTracker")
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [storeDescription]
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }

}
