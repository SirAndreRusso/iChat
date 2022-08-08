//
//  StorageService.swift
//  iChat
//
//  Created by Андрей Русин on 08.08.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService {
    static let shared = StorageService()
    let storageRef = Storage.storage().reference()
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    private var currentUserID: String {
        return Auth.auth().currentUser!.uid
    }
    func uploadImage(photo: UIImage, completion: @escaping(Result<URL, Error>)-> Void) {
        guard let scaledImage = photo.scaledToSafeUploadSize,
              let imageData = scaledImage.jpegData(compressionQuality: 0.4)
        else {
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        avatarsRef.child(currentUserID).putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            self.avatarsRef.child(self.currentUserID).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
}
