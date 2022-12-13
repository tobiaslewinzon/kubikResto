//
//  MainViewController.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 08/12/2022.
//

import UIKit

// MARK: - MainViewController.
/// Root ViewController that holds  the main restaurants tableview.
class MainViewController: UIViewController {
    /// Global instance of the restaurants tableview.
    var restaurantsTableView: UITableView!
    /// Global instance of the MainViewMode.
    var viewModel: MainViewModel?
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup MainViewModel.
        viewModel = MainViewModel(delegate: self)
        // Configure views.
        setupTableView()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Begin fetching restaurants.
        viewModel?.fetchRestaurants()
    }
    
    /// Initializes and configures a tableview to display a list of restaurants.
    private func setupTableView() {
        // Initialization and setup.
        restaurantsTableView = UITableView()
        restaurantsTableView.translatesAutoresizingMaskIntoConstraints = false
        restaurantsTableView.delegate = self
        restaurantsTableView.dataSource = self
        restaurantsTableView.register(RestaurantCell.self, forCellReuseIdentifier: RestaurantCell.reuseIdentifier)
        restaurantsTableView.rowHeight = 140
        restaurantsTableView.backgroundColor = .white
        view.addSubview(restaurantsTableView)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        restaurantsTableView.addSubview(refreshControl)
        
        // Constraints. Anchor to fill the VC.
        NSLayoutConstraint(item: restaurantsTableView as Any, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: restaurantsTableView as Any, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: restaurantsTableView as Any, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: restaurantsTableView as Any, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource.
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let restaurantDataCount = viewModel?.getRestaurants().count else {
            print("No restaurant data in ViewModel")
            return 0
        }
        
        return restaurantDataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Do not try to dequeue cells from an empty response.
        guard !(viewModel?.getRestaurants().isEmpty ?? true), let restuarant = viewModel?.getRestaurants()[indexPath.row] else {
            print("No restaurant data in ViewModel")
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as? RestaurantCell else {
            print("Unable to dequeue cell as RestaurantCell.")
            return UITableViewCell()
        }
    
        cell.configure(restaurant: restuarant)
        return cell
    }
    
    /// Selector method from the RefreshControl. Fetches restaurants.
    @objc func refresh(_ sender: AnyObject) {
        viewModel?.fetchRestaurants()
    }
}

// MARK: - MainViewModelDelegate.
extension MainViewController: MainViewModelDelegate {
    /// Called when restaurants and images are fetched.
    func fetchedRestaurants() {
        refreshControl.endRefreshing()
        restaurantsTableView.reloadData()
    }
}
