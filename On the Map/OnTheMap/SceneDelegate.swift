//
//  SceneDelegate.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 12/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootVC = LoginViewController { [weak self] locations in
            let nvc = UINavigationController(rootViewController: MapViewController(locations: locations))
            self?.window?.rootViewController = nvc
        }
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}

