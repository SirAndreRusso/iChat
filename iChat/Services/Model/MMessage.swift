//
//  MMessage.swift
//  iChat
//
//  Created by Андрей Русин on 13.08.2022.
//

import Foundation
import FirebaseFirestore

struct MMessage: Hashable {
    let content: String
    let senderId: String
    let senderUserName: String
    var sentDate: Date
    let id: String?
    
    init(user: MUser, content: String) {
        senderId = user.id
        senderUserName = user.username
        sentDate = Date()
        id = nil
        self.content = content
    }
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp else {return nil}
        guard let senderID = data["senderID"] as? String else {return nil}
        guard let senderName = data["senderName"] as? String else {return nil}
        guard let content = data["content"] as? String else {return nil}
        
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        self.senderId = senderID
        self.senderUserName = senderName
        self.content = content
    }
    var representation: [String: Any] {
        let rep: [String: Any]  = [
            "created": sentDate,
            "senderID": senderId,
            "senderName": senderUserName,
            "content": content
        ]
        return rep
    }
}
