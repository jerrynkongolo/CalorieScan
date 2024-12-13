//
//  UserModel.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import Foundation
import FirebaseFirestore

struct UserModel: Codable, Identifiable {
    let id: String  // This will be the Firebase Auth UID
    var email: String
    var createdAt: Date
    var lastLoginAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt
        case lastLoginAt
    }
    
    init(id: String, email: String, createdAt: Date = Date(), lastLoginAt: Date = Date()) {
        self.id = id
        self.email = email
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        lastLoginAt = try container.decode(Date.self, forKey: .lastLoginAt)
    }
}

// Extension for Firestore operations
extension UserModel {
    static func fromFirestore(_ document: DocumentSnapshot) -> UserModel? {
        guard 
            let data = document.data(),
            let email = data["email"] as? String,
            let createdAtTimestamp = data["createdAt"] as? Timestamp,
            let lastLoginAtTimestamp = data["lastLoginAt"] as? Timestamp
        else {
            return nil
        }
        
        return UserModel(
            id: document.documentID,
            email: email,
            createdAt: createdAtTimestamp.dateValue(),
            lastLoginAt: lastLoginAtTimestamp.dateValue()
        )
    }
    
    var toFirestore: [String: Any] {
        return [
            "email": email,
            "createdAt": Timestamp(date: createdAt),
            "lastLoginAt": Timestamp(date: lastLoginAt)
        ]
    }
}
