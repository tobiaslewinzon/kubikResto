//
//  RestaurantsDatum.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 08/12/2022.
//

import Foundation

class RestaurantDatum: Codable {
    var data: [Restaurant]
}

class Restaurant: Codable {
    var name, uuid: String?
    var address: Address?
    var aggregateRatings: AggregateRatings?
    var mainPhoto: MainPhoto?
}

struct Address: Codable {
    var street, postalCode, locality, country: String
}

struct AggregateRatings: Codable {
    var thefork, tripadvisor: Rating
}

struct Rating: Codable {
    var ratingValue: Double?
    var reviewCount: Int?
}

struct MainPhoto: Codable {
    var thumbnailUrl: String?
    
    enum MainPhotoKeys: String, CodingKey {
        case thumbnailUrl = "240x135"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MainPhotoKeys.self)
        thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
    }
}
