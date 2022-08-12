//
//  Muser.swift
//  iChat
//
//  Created by Андрей Русин on 15.07.2022.
//

import UIKit
import FirebaseFirestore
struct MUser: Hashable, Decodable {
    var username: String
    var email: String
    var description: String
    var gender: String
    var avatarStringURL: String
    var id: String
    init(username: String, email: String, description: String, gender: String, avatarStringURL: String, id: String) {
        self.username = username
        self.email = email
        self.description = description
        self.gender = gender
        self.avatarStringURL = avatarStringURL
        self.id = id
    }
    init?(document: DocumentSnapshot){
        guard let data = document.data() else {return nil}
        guard let username = data["username"] as? String,
              let email = data["email"] as? String,
              let description = data["description"] as? String,
              let gender = data["gender"] as? String,
              let avatarStringURL = data["avatarStringURL"] as? String,
              let id = data["uid"] as? String else {return nil}
        self.username = username
        self.email = email
        self.description = description
        self.gender = gender
        self.avatarStringURL = avatarStringURL
        self.id = id
              
    }
    init?(document: QueryDocumentSnapshot){
        let data = document.data()
        guard let username = data["username"] as? String,
              let email = data["email"] as? String,
              let description = data["description"] as? String,
              let gender = data["gender"] as? String,
              let avatarStringURL = data["avatarStringURL"] as? String,
              let id = data["uid"] as? String else {return nil}
        self.username = username
        self.email = email
        self.description = description
        self.gender = gender
        self.avatarStringURL = avatarStringURL
        self.id = id
              
    }
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
