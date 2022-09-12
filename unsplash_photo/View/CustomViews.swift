//
//  CustomViews.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit
import SnapKit

final class CustomCV: UICollectionViewCell {
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.frame.size = CGSize(width: 128, height: 130)
        return imageView
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        addSubview(userLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        userLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(5)
            make.leftMargin.rightMargin.equalToSuperview()
        }
    }
}

final class CustomCell: UITableViewCell {
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.frame.size = CGSize(width: 70, height: 70)
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(photoImageView)
        addSubview(usernameLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.leftMargin.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().inset(5)
            make.width.height.equalTo(70)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(5)
            make.bottomMargin.equalToSuperview().inset(5)
            make.leading.equalTo(photoImageView).offset(20)
            make.rightMargin.equalToSuperview()
        }
    }
}
