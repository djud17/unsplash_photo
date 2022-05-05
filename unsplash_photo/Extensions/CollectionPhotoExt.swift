//
//  CollectionPhotoExt.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit
import Kingfisher

extension CollectionPhotoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! CustomCV
        let model = photosArr[indexPath.row]
        let photoUrl = URL(string: model.urls.small)
        
        let processor = DownsamplingImageProcessor(size: cell.photoImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        cell.photoImageView.kf.indicatorType = .activity
        cell.photoImageView.kf.setImage(
            with: photoUrl,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        cell.userLabel.text = model.user.username
        
        return cell
    }
}

extension CollectionPhotoVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "photoDetailVC") as! PhotoDetailVC
        
        viewController.photo = photosArr[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
