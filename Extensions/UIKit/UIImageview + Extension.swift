//
//  UIImageview + Extension.swift
//  iChat
//
//  Created by Андрей Русин on 24.06.2022.
//

import Foundation
import UIKit
extension UIImageView {
    convenience init (image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        self.image = image
        self.contentMode = contentMode
    }
}
extension UIImageView {
    // Меняет цвет картинки
    func setupColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
