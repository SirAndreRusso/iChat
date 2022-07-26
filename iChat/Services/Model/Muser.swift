//
//  Muser.swift
//  iChat
//
//  Created by Андрей Русин on 15.07.2022.
//

import UIKit
struct MUser: Hashable, Decodable {
    var username: String
    var email: String
    var description: String
    var gender: String
    var avatarStringURL: String
    var id: String
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["email"] = email
        rep["description"] = description
        rep["gender"] = gender
        rep["avatarStringURL"] = avatarStringURL
        rep["uid"] = id
       return rep
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: MUser, rhs: MUser) -> Bool{
        return lhs.id == rhs.id
    }
    func contains(filter: String?) -> Bool {
        guard let filter = filter else {return true}
        if filter.isEmpty  {return true}
        let lowercasedFiter = filter.lowercased()
        return username.lowercased().contains(lowercasedFiter)
        
        
    }
}
