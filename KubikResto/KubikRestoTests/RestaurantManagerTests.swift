//
//  RestaurantManagerTests.swift
//  KubikRestoTests
//
//  Created by Tobias Lewinzon on 13/12/2022.
//

@testable import KubikResto
import XCTest
import OHHTTPStubs

class RestaurantManagerTests: XCTestCase {
    
    let didFinishExpectation = XCTestExpectation(description: "didFinish")
    var manager = RestaurantManager()
    
    override func setUp() {
        super.setUp()
        
        // Reset manager for every test.
        manager = RestaurantManager()
        manager.delegate = self
    }
    
    /// Tests fetching restaurant data.
    func testFetchData() {
        setupStubs()
        setupStubsForImages()
        
        // Call manager to get restaurants.
        manager.getRestaurants { success in
            XCTAssertTrue(success)
            
            XCTAssertNotNil(self.manager.restaurantData)
            
            guard let firstRestaurant = self.manager.restaurantData?.data.first else {
                XCTFail("Unable to get first restaurant from list.")
                return
            }
            
            // Test general data.
            XCTAssertEqual(firstRestaurant.name, "Curry Garden")
            XCTAssertEqual(firstRestaurant.uuid, "4eg4e2bn-1080-4e1e-8438-6t90ht123456")
            // Test address.
            XCTAssertEqual(firstRestaurant.address?.street, "89 Rue de Bagnolet")
            XCTAssertEqual(firstRestaurant.address?.locality, "Paris")
            XCTAssertEqual(firstRestaurant.address?.country, "France")
            // Test rating.
            XCTAssertEqual(firstRestaurant.aggregateRatings?.thefork.ratingValue, 9.5)
            XCTAssertEqual(firstRestaurant.aggregateRatings?.thefork.reviewCount, 275)
            XCTAssertEqual(firstRestaurant.aggregateRatings?.tripadvisor.ratingValue, 4.5)
            XCTAssertEqual(firstRestaurant.aggregateRatings?.tripadvisor.reviewCount, 21)
            // Testt photo.
            XCTAssertEqual(firstRestaurant.mainPhoto?.thumbnailUrl, "https://res.cloudinary.com/tf-lab/image/upload/f_auto,q_auto,w_240,h_135/restaurant/b1d8f006-2477-4715-b937-2c34d616dccb/68e364a6-e903-4fb1-9e1e-d91d97457266.jpg")
        }
        
        // Wait for delegate call after downloading the first image.
        wait(for: [didFinishExpectation], timeout: 5)
    }
    
    /// Sets up stubbed call.
    private func setupStubs() {
        stub(condition: isHost("alanflament.github.io")) { request in
          return HTTPStubsResponse(
            fileAtPath: OHPathForFile("restaurants.json", type(of: self))!,
            statusCode: 200,
            headers: ["Content-Type":"application/json"]
          )
        }
    }
    
    /// Sets up stubbed call for images.
    private func setupStubsForImages() {
        stub(condition: isHost("res.cloudinary.com")) { request in
          return HTTPStubsResponse(
            fileAtPath: OHPathForFile("restaurantImage.jpeg", type(of: self))!,
            statusCode: 200,
            headers: ["Content-Type":"image/jpeg"]
          )
        }
    }
}

extension RestaurantManagerTests: RestaurantManagerDelegate {
    
    func finishedDownloading() {
        // Remove delegate from manager so this method is not called again.
        manager.delegate = nil
        // Verify the first image is saved in CoreData.
        XCTAssertNotNil(CoreDataManager.getRestaurantImage(with: "4eg4e2bn-1080-4e1e-8438-6t90ht123456"))
        // Fullfill expectation to finish test.
        didFinishExpectation.fulfill()
    }
}
