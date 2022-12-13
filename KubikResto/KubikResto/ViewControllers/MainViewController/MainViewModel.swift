//
//  MainViewModel.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 08/12/2022.
//

import Foundation

// MARK: - MainViewModelDelegate
protocol MainViewModelDelegate: AnyObject {
    func fetchedRestaurants()
}

// MARK: - MainViewModel
/// ViewModel for the MainViewController.
class MainViewModel {
    /// Global reference to the delegate.
    weak var delegate: MainViewModelDelegate?
    /// Global instance of the RestaurantManager.
    let restaurantManager = RestaurantManager()
    
    // Initialization.
    init(delegate: MainViewModelDelegate) {
        self.delegate = delegate
        restaurantManager.delegate = self
    }
    
    /// Returns current restaurant data held in the RestaurantManager.
    func getRestaurants() -> [Restaurant] {
        return restaurantManager.restaurantData?.data ?? []
    }
    
    /// Calls RestaurantManager to fetch restaurants from API.
    func fetchRestaurants() {
        restaurantManager.getRestaurants { success in
            guard success else { return }
            self.delegate?.fetchedRestaurants()
        }
    }
}

extension MainViewModel: RestaurantManagerDelegate {
    func finishedDownloading() {
        delegate?.fetchedRestaurants()
    }
}
