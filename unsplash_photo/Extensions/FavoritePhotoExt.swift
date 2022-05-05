//
//  FavoritePhotoExt.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import Kingfisher

extension FavoritePhotoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! CustomCV
        let model = favoritePhotos[indexPath.row]
        let photoUrl = URL(string: model.smallUrl)
        
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
        cell.userLabel.text = model.username
        
        return cell
    }
}

extension FavoritePhotoVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "photoDetailVC") as! PhotoDetailVC
        
        let favPhoto = favoritePhotos[indexPath.row]
        let photoUrls = Urls(regular: favPhoto.regularUrl, small: favPhoto.smallUrl)
        let photoUser = User(username: favPhoto.username, location: favPhoto.location)
        let photo = Photo(id: favPhoto.id,
                          createdAt: favPhoto.createdAt,
                          urls: photoUrls,
                          likes: favPhoto.likes,
                          user: photoUser)
        viewController.photo = photo
        
        navigationController?.pushViewController(viewController, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

