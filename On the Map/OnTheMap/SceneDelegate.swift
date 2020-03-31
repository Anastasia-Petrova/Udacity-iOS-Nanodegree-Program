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
        presentLoginVC()
        window?.makeKeyAndVisible()
    }
    
    func presentLoginVC() {
        let rootVC = LoginViewController { [weak self] accountKey, locations in
            self?.presentMapVC(accountKey: accountKey, locations: locations)
        }
        window?.rootViewController = rootVC
    }
    
    func presentMapVC(accountKey: String, locations: [StudentLocation]) {
        let vc = MapViewController(accountKey: accountKey, locations: locations) { [weak self] in
            self?.presentLoginVC()
        }
        let nvc = UINavigationController(rootViewController: vc)
        window?.rootViewController = nvc
    }
}

