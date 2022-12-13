//
//  CoreDataManagerTests.swift
//  KubikRestoTests
//
//  Created by Tobias Lewinzon on 13/12/2022.
//

@testable import KubikResto
import XCTest
import OHHTTPStubs

class CoreDataManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        deleteAllFavorites()
    }
    
    override func tearDown() {
        super.tearDown()
        deleteAllFavorites()
    }
    
    /// Tests adding and removing favorites.
    func testAddAndRemoveFavorites() {
        let dummyUuid = "123"
        
        // Ensure uuid is not found at start.
        XCTAssertNil(CoreDataManager.getCoreDataRestaurant(uuid: dummyUuid))
        
        // Save uuid.
        CoreDataManager.addOrRemoveRestaurantToFavorites(uuid: dummyUuid)
        
        // UUID should be found now.
        XCTAssertNotNil(CoreDataManager.getCoreDataRestaurant(uuid: dummyUuid))
        
        // Call to save uuid, but it should remove it now.
        CoreDataManager.addOrRemoveRestaurantToFavorites(uuid: dummyUuid)
        
        // UUID is nil again.
        XCTAssertNil(CoreDataManager.getCoreDataRestaurant(uuid: dummyUuid))
    }
    
    private func saveDummyData() {
        let dummyRestaurantImage = RestaurantFavorite(context: CoreDataManager.viewContext)
        dummyRestaurantImage.uuid = "123"
        CoreDataManager.viewContext.saveAndThrow()
    }
    
    
    /// Helper method to remove all favorites to clean test.
    private func deleteAllFavorites() {
        // Create NSFetchRequest.
        let request = RestaurantFavorite.fetchRequest()
        
        do {
            let fetchResults = try CoreDataManager.viewContext.fetch(request)
            // For each object, call delete.
            fetchResults.forEach { favorite in
                CoreDataManager.viewContext.delete(favorite)
            }
            
            // Save changes.
            try CoreDataManager.viewContext.save()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
