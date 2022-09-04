//
//  PhotoDetailVC.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit
import Kingfisher

final class PhotoDetailVC: UIViewController {
    private var photoImageView: UIImageView!
    private var photoUsernameLabel: UILabel!
    private var numLikesLabel: UILabel!
    private var createdLabel: UILabel!
    private var locationLabel: UILabel!
    private var addToFavBtn: UIButton!
    
    var photo: Photo?
    private var favPhotos: [FavoritePhoto] = []
    private var addedFav = false
    
    private lazy var margins = self.view.layoutMarginsGuide
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        getPhotoImageView()
        getTitleLabels()
        createFavButton(underView: locationLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let photo = photo else { return }
        
        loadImage(photo)
        setPhotoData(photo)
    }
    
    @objc private func addToFavBtnTapped(_ sender: UIButton) {
        guard let photo = photo else { return }
        
        if addedFav {
            deleteRealmPhoto(photo)
            addedFav = false
            setBtnDefault()
            showAlert("removed from")
        } else {
            createRealmPhoto(photo)
            addedFav = true
            setBtnAdded()
            showAlert("added to")
        }
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
        
        if checkFav() {
            setBtnAdded()
        } else {
            setBtnDefault()
        }
    }
    
    private func setBtnAdded() {
        addToFavBtn.layer.backgroundColor = UIColor.blue.cgColor
        addToFavBtn.setTitle("Remove from Favorites", for: .normal)
        addToFavBtn.setTitleColor(.white, for: .normal)
        addToFavBtn.setTitleColor(.blue, for: .highlighted)
    }
    
    private func setBtnDefault() {
        addToFavBtn.layer.backgroundColor = UIColor.white.cgColor
        addToFavBtn.setTitle("Add to Favorites", for: .normal)
        addToFavBtn.setTitleColor(.blue, for: .normal)
        addToFavBtn.setTitleColor(.white, for: .highlighted)
    }
    
    private func parseDate(_ createdDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: createdDate)!
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
        return "\(components.day ?? 0)-\(components.month ?? 0)-\(components.year ?? 0)"
    }
    
    // Check Photo in Favorites
    private func checkFav() -> Bool {
        addedFav = false
        if let favPhotos = Persistance.shared.realmRead(),
            let photo = photo {
            for fvPh in favPhotos where fvPh.id == photo.id {
                addedFav = true
                break
            }
        }
        return addedFav
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
        let alert = UIAlertController(title: "Attention", message: "This photo was  \(message) Favorites.", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okBtn)
        
        present(alert, animated: true)
    }
    
    private func getPhotoImageView() {
        photoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: 312))
        photoImageView.backgroundColor = .white
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photoImageView)

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: margins.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 312)
        ])
    }
    
    private func getTitleLabels() {
        createdLabel = createTitleLabel(withFont: .systemFont(ofSize: 16), withAlign: .left)
        setLeftLabelConstraints(forLabel: createdLabel, underView: photoImageView)
        
        let userTitleLabel = createTitleLabel(withFont: .boldSystemFont(ofSize: 16), withAlign: .left)
        setLeftLabelConstraints(forLabel: userTitleLabel, underView: createdLabel)
        userTitleLabel.text = "User:"
        
        let locationTitleLabel = createTitleLabel(withFont: .boldSystemFont(ofSize: 16), withAlign: .left)
        setLeftLabelConstraints(forLabel: locationTitleLabel, underView: userTitleLabel)
        locationTitleLabel.text = "Location:"
        
        numLikesLabel = createTitleLabel(withFont: .systemFont(ofSize: 16), withAlign: .right)
        setRightLabelConstraints(forLabel: numLikesLabel, underView: photoImageView)
        
        photoUsernameLabel = createTitleLabel(withFont: .systemFont(ofSize: 16), withAlign: .right)
        setRightLabelConstraints(forLabel: photoUsernameLabel, underView: numLikesLabel)
        
        locationLabel = createTitleLabel(withFont: .systemFont(ofSize: 16), withAlign: .right)
        setRightLabelConstraints(forLabel: locationLabel, underView: photoUsernameLabel)
    }
    
    private func createTitleLabel(withFont font: UIFont, withAlign align: NSTextAlignment) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.textColor = .black
        label.font = font
        label.textAlignment = align
        
        self.view.addSubview(label)
        
        return label
    }
    
    private func setLeftLabelConstraints(forLabel label: UILabel, underView view: UIView) {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            label.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
        ])
    }
    
    private func setRightLabelConstraints(forLabel label: UILabel, underView view: UIView) {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
        ])
    }

    private func createFavButton(underView view: UIView) {
        addToFavBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 80, height: 40))
        addToFavBtn.addTarget(self, action: #selector(addToFavBtnTapped), for: .touchUpInside)
        addToFavBtn.layer.borderColor = UIColor.blue.cgColor
        addToFavBtn.layer.borderWidth = 1.0
        setBtnDefault()
        addToFavBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(addToFavBtn)
        
        NSLayoutConstraint.activate([
            addToFavBtn.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            addToFavBtn.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            addToFavBtn.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
        ])
    }
}
