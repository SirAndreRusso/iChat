//
//  File.swift
//  iChat
//
//  Created by Андрей Русин on 12.08.2022.
//

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class ListenerService {
    static let shared = ListenerService()
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    func usersObserve(users: [MUser], completion: @escaping (Result<[MUser], Error>) -> Void) -> ListenerRegistration? {
        var users = users
        let usersListener = usersRef.addSnapshotListener { (querySnapShot, error) in
            guard let snapShot = querySnapShot else {
                completion(.failure(error!))
                return
            }
            snapShot.documentChanges.forEach { difference in
                guard let muser = MUser(document: difference.document) else {return}
                switch difference.type {
                case .added:
                    guard !users.contains(muser) else {return}
                    guard muser.id != self.currentUserId else {return}
                    users.append(muser)
                    
                case .modified:
                    guard let index = users.firstIndex(of: muser) else {return}
                    users[index] = muser
                case .removed:
                    guard let index = users.firstIndex(of: muser) else {return}
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
            return usersListener
    }
    func waitingChatsObserve(chats: [MChat], completion: @escaping (Result<[MChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatsRef = db.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
        let chatListener = chatsRef.addSnapshotListener { quarySnapShot, error in
            guard let snapShot = quarySnapShot else {
                completion(.failure(error!))
                return
            }
            snapShot.documentChanges.forEach { difference in
                guard let chat = MChat(document: difference.document) else {return}
                switch difference.type {
                case .added:
                    guard !chats.contains(chat) else {return}
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else {return}
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else {return}
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatListener
    }
    func activeChatsObserve(chats: [MChat], completion: @escaping (Result<[MChat], Error>) -> Void) -> ListenerRegistration? {
        var chats = chats
        let chatsRef = db.collection(["users", currentUserId, "activeChats"].joined(separator: "/"))
        let chatListener = chatsRef.addSnapshotListener { quarySnapShot, error in
            guard let snapShot = quarySnapShot else {
                completion(.failure(error!))
                return
            }
            snapShot.documentChanges.forEach { difference in
                guard let chat = MChat(document: difference.document) else {return}
                switch difference.type {
                case .added:
                    guard !chats.contains(chat) else {return}
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else {return}
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else {return}
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatListener
    }
}
