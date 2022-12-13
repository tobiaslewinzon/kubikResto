//
//  RestaurantManager.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 12/12/2022.
//

import Foundation
import UIKit

/// RestaurantManagerDelegate protocol to inform delegate of downloads finishing.
protocol RestaurantManagerDelegate: AnyObject {
    func finishedDownloading()
}

/// Class that encapsulates all Restaurant functionality:
/// fetching and holding data and downloading images.
class RestaurantManager {
    /// Global instance of the RestaurantManagerDelegate.
    weak var delegate: RestaurantManagerDelegate?
    /// Global variable that holds restaurant data.
    var restaurantData: RestaurantDatum?
    
    /// Calls service to get restaurants and returns a boolean in the completion block informing of success.
    func getRestaurants(completion: @escaping ((Bool) -> Void)) {
        // Clean old images, old data and cached responses.
        CoreDataManager.deleteAllImages()
        restaurantData = nil
        URLCache.shared.removeAllCachedResponses()
        
        // Use RestaurantsService to fetch data from API.
        RestaurantsService.getRestaurants { restaurantData in
            
            guard let restaurantData = restaurantData else {
                print("Failure fetching restaurants")
                completion(false)
                return
            }
            
            self.restaurantData = restaurantData
            completion(true)
            
            // Restaurant data successful. Fetch images.
            self.fetchImages()
        }
    }
    
    
    /// Uses restaurant data held in the global restaurantData variable to asynchronically fetch images for each Restaurant.
    /// The function will call 'delegate?.finishedDownloading()' after each download to refresh the necessary views.
    private func fetchImages() {
        
        // Use a DispatchGroup to wait for the previous download to finish before moving on.
        let imagesGroup = DispatchGroup()
        
        // Perform tasks in a background thread inside a performBackgroundTask block to
        // safely handle CoreData.
        AppDelegate().persistentContainer.performBackgroundTask { context in
    
            // Iterate through restaurants and download each image.
            for restaurant in self.restaurantData?.data ?? [] {
                
                defer {
                    context.saveAndThrow()
                }
                
                // Create basic RestaurantImage object to be updated later in the execution.
                let newImageObject = RestaurantImage(context: context)
                newImageObject.uuid = restaurant.uuid
                
                guard let url = restaurant.mainPhoto?.thumbnailUrl, let uuid = restaurant.uuid else {
                    // Data for downloading is corrupted or not available.
                    continue
                }
                
                // Set status to downloading.
                print("Attempting image data call for uuid: \(uuid)")
                newImageObject.status = "downloading"
                
                // Enter group and perform API call.
                imagesGroup.enter()
                ImagesService.getImage(url: url) { image in
                    
                    defer {
                        // Save context and leave group to continue with next download.
                        imagesGroup.leave()
                    }
                    
                    // Check if response has an image object, otherwise set as failed.
                    guard let image = image else {
                        print("Unable to get image object for uuid: \(uuid)")
                        newImageObject.status = "failure"
                        context.saveAndThrow()
                        return
                    }
                    
                    // Use mage object to save binary data and set status to success.
                    newImageObject.image = image.jpegData(compressionQuality: 1)
                    newImageObject.status = "success"
                    context.saveAndThrow()
                   
                    print("Successfully saved image for \(uuid) in core data")
                    
                    // Inform a download has finished.
                    self.delegate?.finishedDownloading()
                }
                
                // Wait for download to finish.
                imagesGroup.wait()
            }
        }
    }
}
