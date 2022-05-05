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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
