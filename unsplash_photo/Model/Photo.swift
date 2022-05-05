//
//  Photo.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//


// MARK: Random photo struct
struct Photo: Codable {
    let id: String
    let createdAt: String
    let urls: Urls
    let likes: Int
    let user: User

    enum CodingKeys: String, CodingKey {
        case id, urls, likes, user
        case createdAt = "created_at"
    }
}

// MARK: - User
struct User: Codable {
    let username: String
    let location: String?
}

// MARK: - Urls
struct Urls: Codable {
    let regular, small: String
}

struct SearchPhoto: Codable {
    
}

class RealmPhoto {
    
}
