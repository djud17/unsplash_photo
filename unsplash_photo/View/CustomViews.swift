//
//  CustomViews.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit

final class CustomCV: UICollectionViewCell {
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.frame = CGRect(x: 0, y: 0, width: 128, height: 130)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(photoImageView)
        self.addSubview(userLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 128),
            userLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 5),
            userLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            userLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)
        ])
    }
}

final class CustomCell: UITableViewCell {
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(photoImageView)
        self.addSubview(usernameLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let margins = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            photoImageView.widthAnchor.constraint(equalToConstant: 70),
            photoImageView.heightAnchor.constraint(equalToConstant: 70),
            usernameLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5),
            usernameLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -5),
            usernameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }
}
