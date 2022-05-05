//
//  PhotoDetailVC.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit
import Kingfisher

class PhotoDetailVC: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoUsernameLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var numLikesLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addToFavBtn: FavoritesBtn!
    
    var photo: Photo?
    var favPhotos: [FavoritePhoto] = []
    private var addedFav = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let photo = photo else { return }
        loadImage(photo)
        setPhotoData(photo)
    }
    
    private func loadImage(_ photo: Photo) {
        let photoUrl = URL(string: photo.urls.regular)
        let processor = DownsamplingImageProcessor(size: photoImageView.bounds.size)
        
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(
            with: photoUrl,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    private func setPhotoData(_ photo: Photo) {
        photoUsernameLabel.text = photo.user.username
        numLikesLabel.text = "\(photo.likes) Likes"
        createdLabel.text = parseDate(photo.createdAt)
        locationLabel.text = photo.user.location
        setBtnDefault()
        
        if checkFav() { setBtnAdded() }
    }
    
    private func setBtnAdded() {
        addToFavBtn.layer.backgroundColor = UIColor.blue.cgColor
        addToFavBtn.tintColor = .white
    }
    
    private func setBtnDefault() {
        addToFavBtn.layer.backgroundColor = UIColor.white.cgColor
        addToFavBtn.tintColor = .blue
    }
    
    private func parseDate(_ createdDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: createdDate)!
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
        return "\(components.day ?? 0)-\(components.month ?? 0)-\(components.year ?? 0)"
    }
    
    private func checkFav() -> Bool {
        addedFav = false
        print(addedFav)
        if let favPhotos = Persistance.shared.realmRead(),
            let photo = photo {
            for fvPh in favPhotos where fvPh.id == photo.id {
                print("heyhey")
                addedFav = true
                break
            }
        }
        print(addedFav)
        return addedFav
    }
    
    @IBAction func addToFavBtnTapped(_ sender: Any) {
        guard let photo = photo else { return }
        
        if addedFav {
            deleteRealmPhoto(photo)
            addedFav = false
            setBtnDefault()
        } else {
            createRealmPhoto(photo)
            addedFav = true
            setBtnAdded()
        }
    }
    
    private func createRealmPhoto(_ photo: Photo) {
        let newPhoto = FavoritePhoto()
        newPhoto.id = photo.id
        newPhoto.createdAt = photo.createdAt
        newPhoto.likes = photo.likes
        newPhoto.regularUrl = photo.urls.regular
        newPhoto.smallUrl = photo.urls.small
        newPhoto.username = photo.user.username
        newPhoto.location = photo.user.location ?? ""
        
        Persistance.shared.realmWrite(newPhoto)
    }
    
    private func deleteRealmPhoto(_ photo: Photo) {
        if let favPhotos = Persistance.shared.realmRead() {
            for fvPh in favPhotos where fvPh.id == photo.id {
                Persistance.shared.realmDelete(fvPh)
                break
            }
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Attention", message: <#T##String?#>, preferredStyle: <#T##UIAlertController.Style#>)
    }
}

