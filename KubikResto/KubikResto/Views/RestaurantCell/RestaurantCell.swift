//
//  RestaurantCell.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 08/12/2022.
//

import UIKit

/// UITableviewCel that holds a restaurant, its image, name, address, rating and a favorite button.
/// Call 'configure(restaurant: Restaurant)' to setup cell before returning.
class RestaurantCell: UITableViewCell {
    
    /// Static instance of the Reuse Identifier.
    static let reuseIdentifier = "restaurantsCell"
       
    /// Container view that holds the restaurant image and spinner.
    let imageContainerView = UIImageView()
    /// UILabel that holds the restaurant image.
    let restaurantImageView = UIImageView()
    /// UILabel that holds the restaurant name.
    let restaurantNameLabel = UILabel()
    /// UILabel that holds the restauran rating.
    let restaurantRatingLabel = UILabel()
    /// UILabel that holds the restaurant address.
    let restaurantAddressLabel = UILabel()
    /// UIActivityIndicator for image loading spinner.
    let imageLoadingSpinner = UIActivityIndicatorView(style: .medium)
    /// UIButton for favoriting restaurants.
    let favoriteButton = UIButton()
    /// RatingView that holds Trip Advisor rating.
    let tripAdvisorView = RatingView()
    /// RatingView that holds The Fork rating.
    let theForkView = RatingView()
    
    /// Sets up restaurantImageView image, spinner or placeholder.
    private func setupImageView(uuid: String?) {
        // Create a container view to center the image and the loading spinner.
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageContainerView)
        // Anchor to the leading side of the cell.
        NSLayoutConstraint(item: imageContainerView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: imageContainerView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: imageContainerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: imageContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        // Add UIImageView inside the container view..
        restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(restaurantImageView)
        // Set its size the same as the container view.
        NSLayoutConstraint(item: restaurantImageView as Any, attribute: .width, relatedBy: .equal, toItem: imageContainerView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: restaurantImageView as Any, attribute: .height, relatedBy: .equal, toItem: imageContainerView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        // Center in container view.
        restaurantImageView.centerInSuperview()
        // Setup some properties.
        restaurantImageView.contentMode = .scaleAspectFill
        restaurantImageView.layer.masksToBounds = true
        
        // Add spinner.
        imageLoadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.addSubview(imageLoadingSpinner)
        imageLoadingSpinner.color = .black
        imageLoadingSpinner.centerInSuperview()
        imageLoadingSpinner.startAnimating()
        
        // Setup image and spinner activity.
        if let image = RestaurantCellViewModel.getImage(uuid: uuid ?? "") {
            // If getImage(uuid: String) provides an image, use it and hide spinner.
            restaurantImageView.image = image
            imageLoadingSpinner.isHidden = true
        } else {
            // Otherwise image is still loading.
            restaurantImageView.image = nil
        }
    }
    
    /// Sets up restaurant name label with passed String.
    private func setupNameLabel(restaurantName: String) {
        // Setup name label.
        restaurantNameLabel.translatesAutoresizingMaskIntoConstraints = false
        restaurantNameLabel.textColor = .black
        restaurantNameLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        restaurantNameLabel.numberOfLines = 2
        contentView.addSubview(restaurantNameLabel)
        
        // Anchor to the top and align leading to the imageContainerView trailing.
        NSLayoutConstraint(item: restaurantNameLabel as Any, attribute: .leading, relatedBy: .equal, toItem: imageContainerView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: restaurantNameLabel as Any, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: restaurantNameLabel as Any, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10).isActive = true
        
        // Set passed text.
        restaurantNameLabel.text = restaurantName
    }
    
    /// Setup restaurant address label with passed String.
    private func setupAddressLabel(address: Address?) {
        // Setup address label.
        restaurantAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        restaurantAddressLabel.textColor = .black
        restaurantAddressLabel.font = UIFont(name: "Helvetica-Light", size: 15)
        restaurantAddressLabel.numberOfLines = 2
        contentView.addSubview(restaurantAddressLabel)
        
        // Anchor below the name label and align leading to the imageContainerView trailing.
        NSLayoutConstraint(item: restaurantAddressLabel as Any, attribute: .leading, relatedBy: .equal, toItem: imageContainerView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: restaurantAddressLabel as Any, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: restaurantAddressLabel as Any, attribute: .top, relatedBy: .equal, toItem: restaurantNameLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        
        // Produce address string.
        let addressString: String = {
            // Guard all properties and provide a default value if they fail.
            guard let street = address?.street, let locality = address?.locality, let country = address?.country else {
                return "No address."
            }
            
            return street + ", " + locality + ", " + country
        }()
        
        restaurantAddressLabel.text = addressString
    }
    
    /// Sets up RatingViews that hold The Fork and Trip Advisor ratings.
    /// - Parameter rating: AggregateRatings object that holds all rating info.
    private func setupRatingLabels(rating: AggregateRatings?) {
        // Prepare platform images.
        let theForkImage = UIImage(named: "theFork") ?? UIImage()
        let tripAdvisorImage = UIImage(named: "tripAdvisor") ?? UIImage()
        
        // Configure theForkView.
        theForkView.setupView(image: theForkImage, rating: rating?.thefork.ratingValue, votes: rating?.thefork.reviewCount)
        theForkView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(theForkView)
        // Anchor top and trailing below the restaurantAddressLabel.
        NSLayoutConstraint(item: theForkView as Any, attribute: .top, relatedBy: .equal, toItem: restaurantAddressLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: theForkView as Any, attribute: .leading, relatedBy: .equal, toItem: restaurantAddressLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: theForkView as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        // Configure tripAdvisorVew.
        tripAdvisorView.setupView(image: tripAdvisorImage, rating: rating?.tripadvisor.ratingValue, votes: rating?.tripadvisor.reviewCount)
        tripAdvisorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tripAdvisorView)
        // Anchor top and trailing below the theForkView.
        NSLayoutConstraint(item: tripAdvisorView as Any, attribute: .top, relatedBy: .equal, toItem: theForkView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tripAdvisorView as Any, attribute: .leading, relatedBy: .equal, toItem: theForkView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tripAdvisorView as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
    }
    
    /// Sets up the favorite button. Uses passed UUID: String to know whether the Restaurant is favorited.
    private func setupFavoriteButton(uuid: String) {
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteButton)
        // Anchor button to the right of the screen below the restaurantAddressLabel and fix its size.
        NSLayoutConstraint(item: favoriteButton as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: favoriteButton as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: favoriteButton as Any, attribute: .top, relatedBy: .equal, toItem: restaurantAddressLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: favoriteButton as Any, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -20).isActive = true
        
        // Create UIAction with a unique identifier so it won't get added multiple times while re-using this cell.
        let action = UIAction(identifier: .init(rawValue: "favorite")) { _ in
            // Add or remove from favorites and update icon.
            CoreDataManager.addOrRemoveRestaurantToFavorites(uuid: uuid)
            self.setFavoriteButtonIcon(uuid: uuid)
        }
        
        favoriteButton.addAction(action, for: .touchUpInside)
    }
    
    /// Uses passed UUID to know whether the restaurant is favorited, and sets up the heart icon style accordingly.
    private func setFavoriteButtonIcon(uuid: String) {
        let image = CoreDataManager.getCoreDataRestaurant(uuid: uuid) != nil ? UIImage(named: "favoriteFilled") : UIImage(named: "favoriteEmpty")
        favoriteButton.setImage(image, for: .normal)
    }
    
    /// Uses passed restaurant to configure and populate the entire cell UI.
    func configure(restaurant: Restaurant) {
        selectionStyle = .none
        backgroundColor = .white
        setupImageView(uuid: restaurant.uuid)
        setupNameLabel(restaurantName: restaurant.name ?? "NULL")
        setupAddressLabel(address: restaurant.address)
        setupRatingLabels(rating: restaurant.aggregateRatings)
        setupFavoriteButton(uuid: restaurant.uuid ?? "")
        setFavoriteButtonIcon(uuid: restaurant.uuid ?? "")
    }
}
