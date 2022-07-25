//
//  AuthErrors.swift
//  iChat
//
//  Created by Андрей Русин on 26.07.2022.
//

import Foundation
enum AuthError {
    case notFilled
    case invalidEmail
    case passwordNotMatched
    case serverError
    case unknownError
}
extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Недопустимый формат почты", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Пароли не совпадают", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        }
    }
    
}
