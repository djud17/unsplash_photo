//
//  FavoritePhotoExt.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import Kingfisher

extension FavoritePhotoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! CustomCell
        let model = favoritePhotos[indexPath.row]
        let photoUrl = URL(string: model.smallUrl)
        
        let processor = DownsamplingImageProcessor(size: cell.photoImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 10)
        cell.photoImageView.kf.indicatorType = .activity
        cell.photoImageView.kf.setImage(
            with: photoUrl,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        cell.usernameLabel.text = model.username
        
        return cell
    }
}

extension FavoritePhotoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
