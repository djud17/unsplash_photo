//
//  CollectionPhotoVC.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit

final class CollectionPhotoVC: UIViewController, UITextFieldDelegate {
    private var searchPhotoTextField: UITextField!
    private var searchPhotoBtn: UIButton!
    private var searchRequestLabel: UILabel!
    private var photoCV: UICollectionView!
    private var errorLabel: UILabel!
    
    private let apiClient: ApiClient = ApiClientImpl()
    var photosArr: [Photo] = []
    
    private lazy var margins = self.view.layoutMarginsGuide
    
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
        searchPhotoTextField = UITextField(frame: CGRect(x: 10, y: 10, width: 300, height: 40))
        searchPhotoTextField.borderStyle = .roundedRect
        searchPhotoTextField.placeholder = "Type keyword to find photos"
        searchPhotoTextField.delegate = self
        
        view.addSubview(searchPhotoTextField)
        
        searchPhotoTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchPhotoTextField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20),
            searchPhotoTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            searchPhotoTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func getSearchBtn() {
        searchPhotoBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 80, height: 40))
        searchPhotoBtn.setTitle("Search", for: .normal)
        searchPhotoBtn.addTarget(self, action: #selector(searchPhotoBtnTapped), for: .touchUpInside)
        
        searchPhotoBtn.layer.borderColor = UIColor.black.cgColor
        searchPhotoBtn.layer.borderWidth = 0.5
        searchPhotoBtn.layer.backgroundColor = UIColor.white.cgColor
        searchPhotoBtn.layer.cornerRadius = 5
        searchPhotoBtn.setTitleColor(.black, for: .normal)
        searchPhotoBtn.setTitleColor(.lightGray, for: .highlighted)
        
        view.addSubview(searchPhotoBtn)
        
        searchPhotoBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchPhotoBtn.topAnchor.constraint(equalTo: searchPhotoTextField.topAnchor),
            searchPhotoBtn.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            searchPhotoBtn.widthAnchor.constraint(equalToConstant: 80),
            searchPhotoBtn.heightAnchor.constraint(equalTo: searchPhotoTextField.heightAnchor),
            searchPhotoBtn.leadingAnchor.constraint(equalTo: searchPhotoTextField.trailingAnchor, constant: 20)
        ])
    }
    
    private func getSearchRequestLabel() {
        searchRequestLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 40))
        searchRequestLabel.textAlignment = .center
        searchRequestLabel.font = UIFont.boldSystemFont(ofSize: 20)
        searchRequestLabel.translatesAutoresizingMaskIntoConstraints = false
        searchRequestLabel.isHidden = true
        
        view.addSubview(searchRequestLabel)
        
        NSLayoutConstraint.activate([
            searchRequestLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            searchRequestLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            searchRequestLabel.topAnchor.constraint(equalTo: searchPhotoTextField.bottomAnchor, constant: 20)
        ])
    }
    
    private func getCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.scrollDirection = .vertical
        
        photoCV = UICollectionView(frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 500), collectionViewLayout: layout)
        photoCV.alwaysBounceVertical = true
        photoCV.register(CustomCV.self, forCellWithReuseIdentifier: "photoCell")
        photoCV.backgroundColor = .white
        photoCV.dataSource = self
        photoCV.delegate = self
        photoCV.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(photoCV)
        
        NSLayoutConstraint.activate([
            photoCV.topAnchor.constraint(equalTo: searchRequestLabel.bottomAnchor, constant: 20),
            photoCV.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            photoCV.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            photoCV.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    private func getErrorLabel() {
        errorLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 40))
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont.systemFont(ofSize: 16)
        errorLabel.textColor = .red
        errorLabel.text = "Data error"
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true
        
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
