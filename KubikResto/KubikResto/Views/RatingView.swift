//
//  RatingView.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 08/12/2022.
//

import UIKit

class RatingView: UIView {
    /// Global instance of the UIStackView holding the logo and the rating info.
    let ratingStack = UIStackView()
    /// Global instance of the UIImageView holding the logo.
    let platformLogo = UIImageView()
    /// Global instance of the UILabel holding the rating string.
    let ratingLabel = UILabel()
   
    /// Populates views and sets up constraints.
    func setupView(image: UIImage?, rating: Double?, votes: Int?) {
        // Setup stack.
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        ratingStack.axis = .horizontal
        ratingStack.distribution = .equalCentering
        ratingStack.alignment = .center
        ratingStack.spacing = 5
        addSubview(ratingStack)
        // Anchor to fill the view.
        NSLayoutConstraint(item: ratingStack as Any, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingStack as Any, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingStack as Any, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: ratingStack as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        // Setup logo imageview.
        platformLogo.translatesAutoresizingMaskIntoConstraints = false
        platformLogo.contentMode = .scaleAspectFit
        platformLogo.image = image
        addSubview(platformLogo)
            
        // Add width and height constraints.
        NSLayoutConstraint(item: platformLogo as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: platformLogo as Any, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        ratingStack.addArrangedSubview(platformLogo)
        
        // Setup rating label.
        ratingLabel.textColor = .black
        ratingLabel.font = UIFont(name: "Helvetica-Light", size: 12)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Produce rating string.
        let ratingString: String = {
            guard let score = rating, let votes = votes else {
                return "No rating."
            }
            
            return "\(score)" + ", " + "\(votes) " + "votes."
        }()
        
        ratingLabel.text = ratingString
        ratingStack.addArrangedSubview(ratingLabel)
    }
}
