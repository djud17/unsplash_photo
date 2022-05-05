//
//  ApiClient.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import Alamofire

enum ApiError: Error {
    case noData
    case wrongData
}

protocol ApiClient {
    func getRandomPhoto(completion: @escaping (Result<[Photo], Error>) -> Void)
}

class ApiClientImpl: ApiClient {
    private let unsplashUrl = "https://api.unsplash.com/photos/"
    private let accessKey = "?client_id=9etn9yyFeBTPlHH66IhXTisehts2b5rGd8Tok48XLK8"
    private let randomPhotoUrl = "random/"
    private let photoCounter = "&count=10"
    
    func getRandomPhoto(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let apiUrl = URL(string: "\(unsplashUrl)\(randomPhotoUrl)\(accessKey)\(photoCounter)")!
        
        AF.request(apiUrl).responseData { response in
            if let data = response.value {
                let randomPhotos: [Photo] = try! JSONDecoder().decode([Photo].self, from: data)
                if response.response?.statusCode == 200 {
                    completion(.success(randomPhotos))
                } else {
                    completion(.failure(ApiError.wrongData))
                }
            } else {
                completion(.failure(ApiError.noData))
            }
        }
    }
}
