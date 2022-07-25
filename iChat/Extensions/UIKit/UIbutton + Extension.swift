//
//  UIbutton + Extension.swift
//  iChat
//
//  Created by Андрей Русин on 24.06.2022.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(title: String,
                     titleColor: UIColor,
                     backGroundColor: UIColor,
                     font: UIFont? = .avenir20(),
                     isShadow: Bool,
                     cornerRadius: CGFloat = 4) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backGroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    func customiedGoogleButton() {
        let googleLogo = UIImageView(image: UIImage(named: "GoogleLogo"), contentMode: .scaleAspectFit)
        googleLogo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(googleLogo)
        NSLayoutConstraint.activate([
            googleLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            googleLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
