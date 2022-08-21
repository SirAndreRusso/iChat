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
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var waitingChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    private var activeChatsRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    var currentUser: MUser!
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void){
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMuser))
                    return
                }
                self.currentUser = muser
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
        if avatarImage == UIImage(named: "Avatar") {
            let defaultAvatar = UIImage(named: "Avatar-placeholder")?.scaledToSafeUploadSize
            var muser = MUser(username: username!, email: email, description: description!, gender: gender!, avatarStringURL: "NotExist", id: id)
            StorageService.shared.uploadImage(photo: defaultAvatar!) { (result) in
                //
                switch result {
                case .success(let url):
                    muser.avatarStringURL = url.absoluteString
                    self.usersRef.document(muser.id).setData(muser.representation) { (error) in
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
        } else {
            
            var muser = MUser(username: username!, email: email, description: description!, gender: gender!, avatarStringURL: "NotExist", id: id)
            StorageService.shared.uploadImage(photo: avatarImage!.scaledToSafeUploadSize!) { (result) in
                //
                switch result {
                case .success(let url):
                    muser.avatarStringURL = url.absoluteString
                    self.usersRef.document(muser.id).setData(muser.representation) { (error) in
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
        }
    }
    func createWaitingChat(message: String, reciever: MUser, completion: @escaping (Result<Void, Error>) -> Void){
        let reference = db.collection(["users", reciever.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        let message = MMessage(user: currentUser, content: message)
        let chat = MChat(friendUsername: currentUser.username,
                         friendAvatarStringURL: currentUser.avatarStringURL,
                         lastMessageContent: message.content,
                         friendId: currentUser.id)
        reference.document(currentUser.id).setData(chat.representation){(error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { (error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    func deleteWaitingChat(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        waitingChatsRef.document(chat.friendId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(Void()))
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    func deleteMessages(chat: MChat, completion: @escaping (Result<Void, Error>)-> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        getWaitingChatMessages(chat: chat) { result in
            switch result {
                
            case .success(let messages):
                for message in messages {
                    guard let documentID = message.id else {return}
                    let messageRef = reference.document(documentID)
                    messageRef.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getWaitingChatMessages(chat: MChat, completion: @escaping (Result<[MMessage], Error>)-> Void) {
        let reference = waitingChatsRef.document(chat.friendId).collection("messages")
        var messages = [MMessage]()
        reference.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let snapShot = querySnapshot else {return}
                for document in snapShot.documents {
                    guard let message = MMessage(document: document) else {return}
                    messages.append(message)
                }
                completion(.success(messages))
            }
        }
    }
    func changeToActive(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        getWaitingChatMessages(chat: chat) { result in
            switch result {
                
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { result in
                    switch result {
                        
                    case .success():
                        self.createActiveChat(chat: chat, messages: messages) { result in
                            switch result {
                                
                            case .success():
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping (Result<Void, Error>) -> Void) {
        let messageRef = activeChatsRef.document(chat.friendId).collection("messages")
        activeChatsRef.document(chat.friendId).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            for message in messages {
                messageRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    func sendMessage(chat: MChat, message: MMessage, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendRef = usersRef.document(chat.friendId).collection("activeChats").document(currentUser.id)
        let friendMessageRef = friendRef.collection("messages")
        let myMessageRef = usersRef.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
        
        let chatForFriend = MChat(friendUsername: currentUser.username,
                                  friendAvatarStringURL: currentUser.avatarStringURL,
                                  lastMessageContent: message.content,
                                  friendId: currentUser.id)
        friendRef.setData(chatForFriend.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                myMessageRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.success(Void()))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
}
