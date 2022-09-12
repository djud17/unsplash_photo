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
        
        let collectionPhotoVC = UINavigationController(rootViewController: CollectionPhotoVC())
        collectionPhotoVC.tabBarItem.title = "Photos"
        collectionPhotoVC.tabBarItem.image = UIImage(systemName: "photo.on.rectangle.angled")
        
        let favoritePhotoVC = UINavigationController(rootViewController: FavoritePhotoVC())
        favoritePhotoVC.tabBarItem.title = "Favorite photos"
        favoritePhotoVC.tabBarItem.image = UIImage(systemName: "suit.heart.fill")
        
        let arrayVC: [UIViewController] = [collectionPhotoVC, favoritePhotoVC]
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = arrayVC
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}
