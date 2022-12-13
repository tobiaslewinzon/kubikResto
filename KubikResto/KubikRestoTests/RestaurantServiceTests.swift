//
//  RestaurantServiceTests.swift
//  KubikRestoTests
//
//  Created by Tobias Lewinzon on 13/12/2022.
//

@testable import KubikResto
import XCTest
import OHHTTPStubs

class RestaurantServiceTests: XCTestCase {

    /// Tests parsing JSON as Restaurant Datum and service making call.
    func testGetRestaurantData() {
        setupStubs()
        
        let didFinishExpectation = expectation(description: "didFinish")
        
        RestaurantsService.getRestaurants { restaurantData in
            // Test data.
            XCTAssertNotNil(restaurantData?.data)
            XCTAssertEqual(restaurantData?.data.count, 10)
            didFinishExpectation.fulfill()
        }
        
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
}
