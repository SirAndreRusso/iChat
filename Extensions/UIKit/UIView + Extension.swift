//
//  UIView + Extension.swift
//  iChat
//
//  Created by Андрей Русин on 20.07.2022.
//

import UIKit
extension UIView {
    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: .gradientStartColor(), endColor: .gradientEndColor())
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            print("123")
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
