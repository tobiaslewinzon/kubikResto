    //
//  UIViewExtension.swift
//  KubikResto
//
//  Created by Tobias Lewinzon on 08/12/2022.
//

import UIKit
/// UIViewController extension with custom methods to handle constraints programmatically.
extension UIView {
    
    /// Centers view in superview.
    func centerInSuperview() {
        guard let superview = superview else {
            print("Unable to center view. Superview not available.")
            return
        }
        
        centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 0).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0).isActive = true
    }
}
