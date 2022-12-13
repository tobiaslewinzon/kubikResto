//
//  RestaurantCellViewModel.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 13/12/2022.
//

import Foundation
import UIKit

/// ViewModel for the RestaurantCell.
class RestaurantCellViewModel {
    
    /// Uses passed UUID to match a RestaurantImage object in core data and check on its status and image properties.
    /// The function will return the nil, a placeholder, or the actual restaurant image depending on the status being downloading, failure or success respectively.
    static func getImage(uuid: String) -> UIImage? {
        
        // While there is no object in core data, return nil. Download hasn't began yet.
        guard let restaurantImage = CoreDataManager.getRestaurantImage(with: uuid) else {
            return nil
        }
        
        // Iterate through statuses.
        switch restaurantImage.status {
        case "downloading":
            // Still downloading, we want just a spinner.
            return nil
        case "success":
            // Try to create UIImage with the data. If not possible, return the placeholder.
            guard let imageData = restaurantImage.image, let image = UIImage(data: imageData) else {
                return UIImage(named: "placeholder")
            }
            
            return image
            
        default:
            return UIImage(named: "placeholder")
        }
    }
}
