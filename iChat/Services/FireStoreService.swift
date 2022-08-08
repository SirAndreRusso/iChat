//
//  FireStoreService.swift
//  iChat
//
//  Created by Андрей Русин on 26.07.2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FirestoreService{
    static let shared = FirestoreService()
    let db = Firestore.firestore()
    private var userRef: CollectionReference {
        return db.collection("users")
    }
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void){
        let docRef = userRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMuser))
                    return
                }
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, gender: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        guard Validators.isFilled(username: username, description: description, gender: gender) else {
            completion(.failure(UserError.notFilled))
            return
        }
        guard avatarImage != UIImage(named: "Avatar") else {
            completion(.failure(UserError.photoNotExists))
            return
        }
        
        var muser = MUser(username: username!, email: email, description: description!, gender: gender!, avatarStringURL: "NotExist", id: id)
        StorageService.shared.uploadImage(photo: avatarImage!) { (result) in
            //
            switch result {
            case .success(let url):
                muser.avatarStringURL = url.absoluteString
                self.userRef.document(muser.id).setData(muser.representation) { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(muser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        self.userRef.document(muser.id).setData(muser.representation) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(muser))
            }
        }
    }
}
