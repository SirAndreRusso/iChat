//
//  UserErrors.swift
//  iChat
//
//  Created by Андрей Русин on 26.07.2022.
//

import Foundation
import SwiftUI

enum UserError {
    case notFilled
    case photoNotExists
    case cannotGetUserInfo
    case cannotUnwrapToMuser
}
extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExists:
            return NSLocalizedString("Сначала выберите фото профиля", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Невозможно загрузить информацию о User из Firebase", comment: "")
        case .cannotUnwrapToMuser:
            return NSLocalizedString("Невозможно конвертировать User в Muser", comment: "")
        }
    }
}
