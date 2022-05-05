//
//  FavoritePhotoVC.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit

class FavoritePhotoVC: UIViewController {
    @IBOutlet weak var favoritePhotosCV: UICollectionView!
    
    var favoritePhotos: [FavoritePhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readData()
    }
    
    private func readData() {
        if let fvPhoto = Persistance.shared.realmRead() {
            favoritePhotos.removeAll()
            fvPhoto.forEach {favoritePhotos.append($0)}
            
            favoritePhotosCV.reloadData()
        }
    }
}
