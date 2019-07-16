//
//  Gradient.swift
//  Wrath
//
//  Created by Thomas Loring on 7/9/19.
//  Copyright © 2019 Thomas Loring. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func createGradientBackground(topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [bottomColor.cgColor, topColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
