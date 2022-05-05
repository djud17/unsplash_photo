//
//  CollectionPhotoVC.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit

class CollectionPhotoVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchPhotoTextField: UITextField!
    @IBOutlet weak var searchPhotoBtn: SearchBtn!
    @IBOutlet weak var searchRequestLabel: UILabel!
    @IBOutlet weak var photoCV: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let apiClient: ApiClient = ApiClientImpl()
    var photosArr: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchPhotoTextField.delegate = self
        
        navigationItem.title = "Photos"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadData()
    }
    
    @IBAction func searchPhotoBtnTapped(_ sender: Any) {
        let searchWord = searchPhotoTextField.text ?? ""
        searchRequestLabel.text = "Photos for request: \(searchWord)"
        searchRequestLabel.isHidden = false
        
        apiClient.getSearchPhoto(searchWord) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photo):
                    self.photosArr = photo.results
                case .failure:
                    self.photosArr = []
                }
                self.photoCV.reloadData()
            }
        }
        view.endEditing(true)
    }
    
    private func loadData() {
        apiClient.getRandomPhoto { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photo):
                    self.photosArr = photo
                case .failure:
                    self.photosArr = []
                    self.errorLabel.isHidden = false
                }
                self.photoCV.reloadData()
            }
        }
    }
}
