//
//  AuthNavigationDelegate.swift
//  iChat
//
//  Created by Андрей Русин on 26.07.2022.
//

import Foundation
protocol AuthNavigationDelegate: AnyObject {
    func toLoginVC()
    func toRegistrationVC()
}
