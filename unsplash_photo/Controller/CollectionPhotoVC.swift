//
//  CollectionPhotoVC.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit
import Kingfisher
import SnapKit

final class CollectionPhotoVC: UIViewController {
    private var searchPhotoTextField = UITextField()
    private var searchPhotoBtn = UIButton()
    private var searchRequestLabel = UILabel()
    private var photoCV: UICollectionView!
    private var errorLabel = UILabel()
    private let apiClient: ApiClient = ApiClientImpl()
    private var photosArr: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "Photos"
        navigationController?.navigationBar.prefersLargeTitles = true
        getTextField()
        getSearchBtn()
        getSearchRequestLabel()
        getCollectionView()
        getErrorLabel()
    }
    
    @objc private func searchPhotoBtnTapped(_ sender: Any) {
        let searchWord = searchPhotoTextField.text ?? ""
        if searchWord != "" {
            searchRequestLabel.text = "Photos for request: \(searchWord)"
            searchRequestLabel.isHidden = false
            apiClient.getSearchPhoto(searchWord) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let photo):
                        self.photosArr = photo.results
                    case .failure:
                        self.photosArr = []
                        self.errorLabel.isHidden = false
                    }
                    self.photoCV.reloadData()
                }
            }
        } else {
            loadData()
            searchRequestLabel.isHidden = true
        }
        view.endEditing(true)
    }
    
    private func loadData() {
        apiClient.getRandomPhoto { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photo):
                    self.photosArr = photo
                case .failure:
                    self.photosArr = []
                    self.errorLabel.isHidden = false
                }
                self.photoCV.reloadData()
            }
        }
    }
    
    private func getTextField() {
        searchPhotoTextField.borderStyle = .roundedRect
        searchPhotoTextField.placeholder = "Type keyword to find photos"
        searchPhotoTextField.delegate = self
        view.addSubview(searchPhotoTextField)
        
        searchPhotoTextField.snp.makeConstraints { make in
            make.topMargin.equalTo(20)
            make.leftMargin.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func getSearchBtn() {
        searchPhotoBtn.addTarget(self, action: #selector(searchPhotoBtnTapped), for: .touchUpInside)
        searchPhotoBtn.layer.borderColor = UIColor.black.cgColor
        searchPhotoBtn.layer.borderWidth = 0.5
        searchPhotoBtn.layer.backgroundColor = UIColor.white.cgColor
        searchPhotoBtn.layer.cornerRadius = 5
        searchPhotoBtn.setTitle("Search", for: .normal)
        searchPhotoBtn.setTitleColor(.black, for: .normal)
        searchPhotoBtn.setTitleColor(.lightGray, for: .highlighted)
        view.addSubview(searchPhotoBtn)
 
        searchPhotoBtn.snp.makeConstraints { make in
            make.top.equalTo(searchPhotoTextField.snp.top)
            make.rightMargin.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(searchPhotoTextField.snp.height)
            make.leading.equalTo(searchPhotoTextField.snp.trailing).offset(20)
        }
    }
    
    private func getSearchRequestLabel() {
        searchRequestLabel.textAlignment = .center
        searchRequestLabel.font = .boldSystemFont(ofSize: 20)
        searchRequestLabel.isHidden = true
        view.addSubview(searchRequestLabel)
        
        searchRequestLabel.snp.makeConstraints { make in
            make.leftMargin.rightMargin.equalToSuperview()
            make.top.equalTo(searchPhotoTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
    }
    
    private func getCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.scrollDirection = .vertical
        
        photoCV = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        photoCV.register(CustomCV.self, forCellWithReuseIdentifier: "photoCell")
        photoCV.backgroundColor = .white
        photoCV.alwaysBounceVertical = true
        photoCV.dataSource = self
        photoCV.delegate = self
        view.addSubview(photoCV)
        
        photoCV.snp.makeConstraints { make in
            make.top.equalTo(searchRequestLabel.snp.bottom).offset(10)
            make.leftMargin.rightMargin.equalToSuperview()
            make.bottomMargin.equalToSuperview().offset(-20)
        }
    }
    
    private func getErrorLabel() {
        errorLabel.textAlignment = .center
        errorLabel.font = .systemFont(ofSize: 16)
        errorLabel.textColor = .red
        errorLabel.text = "Data error"
        errorLabel.isHidden = true
        view.addSubview(errorLabel)
        
        errorLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}

extension CollectionPhotoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        if let cell = cell as? CustomCV {
            let model = photosArr[indexPath.row]
            let photoUrl = URL(string: model.urls.small)
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
            cell.userLabel.text = model.user.username
        }
        return cell
    }
}

extension CollectionPhotoVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photosArr[indexPath.row]
        let viewController = PhotoDetailVC(photo)
        navigationController?.pushViewController(viewController, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension CollectionPhotoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchPhotoBtnTapped(self)
        textField.resignFirstResponder()
        return true
    }
}
