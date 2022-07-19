//
//  SelfConfigurationCell.swift
//  iChat
//
//  Created by Андрей Русин on 14.07.2022.
//

import Foundation
protocol SelfConfiguringCell {
    static var reuseId: String {get}
    func configure<U: Hashable>(with value: U)
}
