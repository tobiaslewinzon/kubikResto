//
//  ImagesService.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 13/12/2022.
//

import Foundation
import UIKit
import Alamofire

/// Service in charge of getting images from API
class ImagesService {
    
    /// Uses passed URL to fetch the image and passes it as UIImage in the completion parameter.
    static func getImage(url: String, completion: @escaping ((UIImage?) -> Void)) {
        AF.request(url).response { response in
            
            let statusCode = response.response?.statusCode ?? 0
            
            // Try to create UIImage object to validate data.
            guard let responseData = response.data, let image = UIImage(data: responseData) else {
                print("Error fetching image data. Status code: \(statusCode)")
                completion(nil)
                return
            }
            
            completion(image)
        }
    }
}
