//
//  CoreDataManager.swift
//  CryptoBit
//
//  Created by Wycliff Kamau on 26/04/2025.
//


import CoreData

final class CoreDataManager {
  static let shared = CoreDataManager()

  let container: NSPersistentContainer

  private init() {
    container = NSPersistentContainer(name: "CryptoBit")
    container.loadPersistentStores { _, error in
      if let e = error {
        fatalError("Core Data failed to load: \(e)")
      }
    }
  }

  var context: NSManagedObjectContext {
    container.viewContext
  }

  func saveContext() {
    guard context.hasChanges else { return }
    do {
      try context.save()
    } catch {
      print("Core Data save error:", error)
    }
  }
}
