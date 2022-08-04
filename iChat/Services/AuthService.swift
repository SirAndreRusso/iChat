//
//  AuthService.swift
//  iChat
//
//  Created by Андрей Русин on 25.07.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()
    func login(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void){
        guard let email = email,
              let password = password
        else {
            completion(.failure(AuthError.notFilled))
            return
        }
        
        auth.signIn(withEmail: email, password: password) {(result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFilled))
            return
        }
        guard password!.lowercased() == confirmPassword?.lowercased() else {
            completion(.failure(AuthError.passwordNotMatched))
            return
        }
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        auth.createUser(withEmail: email!, password: password!)  { (result, error) in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    func googleSignIn(presentVC vc: UIViewController, completion: @escaping (Result<User, Error>)-> Void){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        let vc = vc
        GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) {  (user, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { (result, error) in
                guard let result = result else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(result.user))
            }
            
        }
    }
}
