//
//  Photo.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import RealmSwift

// MARK: Photo struct
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

struct User: Codable {
    let username: String
    let location: String?
}

struct Urls: Codable {
    let regular, small: String
}

// MARK: Photo struct for search
struct SearchPhoto: Codable {
    let results: [Photo]
}

// MARK: Favorite Photo class for Realm
final class FavoritePhoto: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var createdAt: String = ""
    @objc dynamic var smallUrl: String = ""
    @objc dynamic var regularUrl: String = ""
    @objc dynamic var likes: Int = 0
    @objc dynamic var username: String = ""
    @objc dynamic var location: String = ""
}
