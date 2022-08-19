//
//  MMessage.swift
//  iChat
//
//  Created by Андрей Русин on 13.08.2022.
//

import Foundation
import FirebaseFirestore
import MessageKit
struct Sender: SenderType {
    var senderId: String
    
    var displayName: String
}
struct MMessage: Hashable, MessageType {
    let content: String
    let id: String?
    var sentDate: Date
    
    var sender: SenderType
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
   
  
    
   
    
    init(user: MUser, content: String) {
        sender = Sender(senderId: user.id, displayName: user.username)
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
        self.sender = Sender(senderId: senderID, displayName: senderName)
        self.content = content
    }
    var representation: [String: Any] {
        let rep: [String: Any]  = [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName,
            "content": content
        ]
        return rep
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}
