//
//  MMessage.swift
//  iChat
//
//  Created by Андрей Русин on 13.08.2022.
//

import Foundation
import FirebaseFirestore
import MessageKit

// MARK: - SenderType struct needed to work with MessageKIT

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

// MARK: - ImageItem struct needed to work with MediaItem type in message kind

struct ImageItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

// MARK: - MMessage struct

struct MMessage: Hashable, MessageType {
    let id: String?
    let content: String
    var sentDate: Date
    var sender: SenderType
    var messageId: String {
        return id ?? UUID().uuidString
    }
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size)
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
// MARK: - init with user and content
    
    init(user: MUser, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.username)
        sentDate = Date()
        id = nil
    }
    
// MARK: - init? with QueryDocumentSnapshot
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sentDate = data["created"] as? Timestamp else {return nil}
        guard let senderID = data["senderID"] as? String else {return nil}
        guard let senderName = data["senderName"] as? String else {return nil}
//        guard let content = data["content"] as? String else {return nil}
        
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        self.sender = Sender(senderId: senderID, displayName: senderName)
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        }else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            self.content = ""
        } else {
            return nil
        }
    }
    
// MARK: - init with user and image
    
    init(user: MUser, image: UIImage) {
        sender = Sender(senderId: user.id, displayName: user.username)
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
        
    }
    
// MARK: - representation
    
    var representation: [String: Any] {
        var rep: [String: Any]  = [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName
        ]
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        return rep
    }
    
// MARK: - required functions to conform Hashable and Equatable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

// MARK: - Comparable protocol to sort messages

extension MMessage: Comparable {
    static func < (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
    
}
