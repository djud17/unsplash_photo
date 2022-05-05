//
//  CustomViews.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit

class CustomCV: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
}

class FavoritesBtn: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBtn()
    }
    
    private func setupBtn() {
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1.0
        layer.backgroundColor = UIColor.white.cgColor
        tintColor = .blue
    }
}

class SearchBtn: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBtn()
    }
    
    private func setupBtn() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
        layer.backgroundColor = UIColor.white.cgColor
        tintColor = .black
    }
}
