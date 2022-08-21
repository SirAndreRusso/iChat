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
    private var chatsRef: StorageReference {
        return storageRef.child("chats")
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
    func uploadImageMessage(photo: UIImage, from: MUser, to chat: MChat, completion: @escaping(Result<URL, Error>)-> Void) {
        guard let scaledImage = photo.scaledToSafeUploadSize,
              let imageData = scaledImage.jpegData(compressionQuality: 0.4)
        else {
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
//        let uid: String = Auth.auth().currentUser!.uid
        let chatName = [chat.friendUsername, from.username].joined()
        self.chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metadata) { metadata, error in
            guard metadata != nil else {
                completion(.failure(error!))
                return
            }
            self.chatsRef.child(chatName).child(imageName).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
    }
    func downloadImage(url: URL, completion: @escaping(Result<UIImage?, Error>)-> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1*1024*1024)
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)))
        }
    }
}
