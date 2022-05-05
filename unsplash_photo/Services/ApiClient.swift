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
    func getSearchPhoto(_ searchWord: String, completion: @escaping (Result<SearchPhoto, Error>) -> Void)
}

class ApiClientImpl: ApiClient {
    // Parameters for request
    private let unsplashUrl = "https://api.unsplash.com/"
    private let accessKey = "?client_id=9etn9yyFeBTPlHH66IhXTisehts2b5rGd8Tok48XLK8"
    
    // Parameters for random photo request
    private let randomPhotoUrl = "photos/random/"
    private let photoCounter = "&count=10"
    
    // Parameters for search photo request
    private let searchPhotoUrl = "search/photos/"
    private let searchRequest = "&query=fruits"
    
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

    func getSearchPhoto(_ searchWord: String, completion: @escaping (Result<SearchPhoto, Error>) -> Void) {
        let strUrl = "\(unsplashUrl)\(searchPhotoUrl)\(accessKey)\(searchRequest)\(searchWord)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let apiUrl = URL(string: strUrl)!
        
        AF.request(apiUrl).responseData { response in
            if let data = response.value {
                let searchPhotos: SearchPhoto = try! JSONDecoder().decode(SearchPhoto.self, from: data)
                if response.response?.statusCode == 200 {
                    completion(.success(searchPhotos))
                } else {
                    completion(.failure(ApiError.wrongData))
                }
            } else {
                completion(.failure(ApiError.noData))
            }
        }
    }
}
