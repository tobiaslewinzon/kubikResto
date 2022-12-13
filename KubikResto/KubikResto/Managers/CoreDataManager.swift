//
//  CoreDataManager.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 12/12/2022.
//

import Foundation
import UIKit
import CoreData

/// Class that encapsulates all CoreData functionality.
class CoreDataManager {
    
    /// Global static instance of the viewContext.
    static let viewContext = AppDelegate().persistentContainer.viewContext
    
    /// Returns RestaurantImage object matching passed UUID.
    static func getRestaurantImage(with uuid: String) -> RestaurantImage? {
        // Create NSFetchRequest with an NSPredicate to match UUID.
        let request = RestaurantImage.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", uuid)
        request.predicate = predicate
        
        do {
            let fetchResults = try viewContext.fetch(request)
            return fetchResults.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Cleans CoreData of cached images.
    static func deleteAllImages() {
        // Create NSFetchRequest.
        let request = RestaurantImage.fetchRequest()
        
        do {
            let fetchResults = try viewContext.fetch(request)
            // For each object, call delete.
            fetchResults.forEach { logo in
                viewContext.delete(logo)
            }
            // Save changes.
            try viewContext.save()
            
            print("Successfully removed all \(fetchResults.count) images from core data.")
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Uses passed UUID to match any saved one in CoreData. If there isn´t one, adds it. If there is one, removes it.
    static func addOrRemoveRestaurantToFavorites(uuid: String) {
        defer {
            viewContext.saveAndThrow()
        }
        
        guard let coreDataRestaurant = getCoreDataRestaurant(uuid: uuid) else {
            // Not saved yet. Add it.
            let restaurantCoreData = RestaurantFavorite(context: viewContext)
            restaurantCoreData.uuid = uuid
            return
        }
        
        // Already saved. Remove it.
        viewContext.delete(coreDataRestaurant)
    }
    
    /// Uses passed UUID to return the saved restaurant favorite object.
    static func getCoreDataRestaurant(uuid: String) -> RestaurantFavorite? {
        // Create NSFetchRequest with an NSPredicate to match UUID.
        let request = RestaurantFavorite.fetchRequest()
        let predicate = NSPredicate(format: "uuid = %@", uuid)
        request.predicate = predicate
        
        do {
            let fetchResults = try viewContext.fetch(request)
            // Return result.
            return fetchResults.first
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension NSManagedObjectContext {
    
    /// Calls NSManagedObjectContext regular save() function but resolves the nightmare of trying  do - try - catch every time.
    func saveAndThrow() {
        do {
            try save()
            
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

extension RestaurantImage {
    // Solution from https://stackoverflow.com/questions/51851485/multiple-nsentitydescriptions-claim-nsmanagedobject-subclass#:~:text=24-,As,-%40Kamchatka%20pointed%20out
    /// Custom initializer to avoid CoreData warnings on multiple multiple NSEntityDescriptions claims.
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
