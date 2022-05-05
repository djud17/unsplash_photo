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
    
    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let photo = photo else { return }
        loadImage(photo)
        setPhotoData(photo)
    }
    
    private func loadImage(_ photo: Photo) {
        let photoUrl = URL(string: photo.urls.regular)!
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: photo.createdAt)!
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
        createdLabel.text = "\(components.day ?? 0)-\(components.month ?? 0)-\(components.year ?? 0)"
    }
    @IBAction func addToFavBtnTapped(_ sender: Any) {
    }
}

