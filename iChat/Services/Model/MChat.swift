//
//  MChat.swift
//  iChat
//
//  Created by Андрей Русин on 15.07.2022.
//

import UIKit
struct MChat: Hashable, Decodable {
    var friendUsername: String
    var friendAvatarStringURL  : String
    var lastMessageContent: String
    var friendId: String
    var representation: [String: Any] {
        var rep = ["friendUsername": friendUsername]
        rep["friendAvatarStringURL"] = friendAvatarStringURL
        rep["lastMessage"] = lastMessageContent
        rep["friendId"] = friendId
        return rep
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    static func == (lhs: MChat, rhs: MChat) -> Bool{
        return lhs.friendId == rhs.friendId
    }
}
