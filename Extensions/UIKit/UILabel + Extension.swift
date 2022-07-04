//
//  UILabel + Extension.swift
//  iChat
//
//  Created by Андрей Русин on 24.06.2022.
//

import Foundation
import UIKit
extension UILabel {
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        self.text = text
        self.font = font
    }
}
