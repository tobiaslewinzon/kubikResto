//
//  RestaurantsService.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 08/12/2022.
//

import Foundation
import Alamofire

/// Service in charge of fetching restaurants from API.
class RestaurantsService {
    static let restaurantsUrl = "https://alanflament.github.io/TFTest/test.json"
    
    /// Uses the restaurant URL to fetch restaurants from API.
    static func getRestaurants(completion: @escaping ((RestaurantDatum?) -> Void)) {
        AF.request(restaurantsUrl).response { response in
            
            let statusCode = response.response?.statusCode ?? 0
            
            // Try to decode data as RestaurantDatum.
            let decoder = JSONDecoder()
            guard let responseData = response.data, let restaurantData = try? decoder.decode(RestaurantDatum.self, from: responseData) else {
                print("Error fetching restaurant data. Status code: \(statusCode)")
                completion(nil)
                return
            }
            
            completion(restaurantData)
        }
    }
}
