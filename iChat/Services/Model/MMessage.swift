//
//  MMessage.swift
//  iChat
//
//  Created by Андрей Русин on 13.08.2022.
//

import Foundation
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
