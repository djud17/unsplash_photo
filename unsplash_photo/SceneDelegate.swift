//
//  SceneDelegate.swift
//  unsplash_photo
//
//  Created by Давид Тоноян  on 05.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = UITabBarController()
        
        var arrayVC: [UIViewController] = []
        let collectionPhotoVC = UINavigationController(rootViewController: CollectionPhotoVC())
        collectionPhotoVC.tabBarItem.title = "Photos"
        collectionPhotoVC.tabBarItem.image = UIImage(systemName: "photo.on.rectangle.angled")
        
        let favoritePhotoVC = UINavigationController(rootViewController: FavoritePhotoVC())
        favoritePhotoVC.tabBarItem.title = "Favorite photos"
        favoritePhotoVC.tabBarItem.image = UIImage(systemName: "suit.heart.fill")
        
        arrayVC.append(collectionPhotoVC)
        arrayVC.append(favoritePhotoVC)
        tabBarController.viewControllers = arrayVC
        
        
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}

