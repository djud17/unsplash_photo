//
//  CollectionPhotoVC.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit

class CollectionPhotoVC: UIViewController {
    @IBOutlet weak var searchPhotoTextField: UITextField!
    @IBOutlet weak var searchPhotoBtn: SearchBtn!
    @IBOutlet weak var searchRequestLabel: UILabel!
    @IBOutlet weak var photoCV: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func searchPhotoBtnTapped(_ sender: Any) {
    }
}
