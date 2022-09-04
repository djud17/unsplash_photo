//
//  Persistance.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import RealmSwift

final class Persistance {
    static let shared = Persistance()
    let realm = try! Realm()
    
    func realmWrite(_ photo: Any) {
        try! realm.write{
            realm.add(photo as! Object)
        }
    }
    
    func realmDelete(_ photo: FavoritePhoto) {
        try! realm.write{
            realm.delete(photo)
        }
    }
    
    func realmRead() -> Results<FavoritePhoto>? {
        let array = realm.objects(FavoritePhoto.self)
        return array
    }
}
