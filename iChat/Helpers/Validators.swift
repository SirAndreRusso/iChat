//
//  Validators.swift
//  iChat
//
//  Created by Андрей Русин on 26.07.2022.
//

import Foundation
class Validators {
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        guard let password = password,
              let email = email,
              let confirmPassword = confirmPassword,
              password != "",
              confirmPassword != "",
              email != "" else {return false}
        return true
    }
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
