//
//  UIStackView + Extention.swift
//  iChat
//
//  Created by Андрей Русин on 24.06.2022.
//

import Foundation
import UIKit
extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis:NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
    }
}
