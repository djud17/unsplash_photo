//
//  FavoritePhotoVC.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit
import Kingfisher

final class FavoritePhotoVC: UITableViewController {
    private var favoritePhotos: [FavoritePhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readData()
    }
    
    private func setupView() {
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "favoriteCell")
        tableView.backgroundColor = .white
    }
    
    private func readData() {
        if let fvPhoto = Persistance.shared.realmRead() {
            favoritePhotos.removeAll()
            fvPhoto.forEach {favoritePhotos.append($0)}
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritePhotos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        if let cell = cell as? CustomCell {
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
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favPhoto = favoritePhotos[indexPath.row]
        let photoUrls = Urls(regular: favPhoto.regularUrl, small: favPhoto.smallUrl)
        let photoUser = User(username: favPhoto.username, location: favPhoto.location)
        let photo = Photo(id: favPhoto.id,
                          createdAt: favPhoto.createdAt,
                          urls: photoUrls,
                          likes: favPhoto.likes,
                          user: photoUser)
        let viewController = PhotoDetailVC(photo)
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
