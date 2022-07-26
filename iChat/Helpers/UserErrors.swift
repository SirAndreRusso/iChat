//
//  UserErrors.swift
//  iChat
//
//  Created by Андрей Русин on 26.07.2022.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExists
}
extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExists:
            return NSLocalizedString("Сначала выберите фото профиля", comment: "")
        }
    }
}
