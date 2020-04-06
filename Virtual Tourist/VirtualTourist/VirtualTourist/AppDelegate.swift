//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Anastasia Petrova on 03/04/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit
import EasyCoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let dataController = DataController(modelName: "VirtualTourist")
    let controller = CoreDataController<Pin, PinViewModel>(entityName: "Pin")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dataController.load()
        controller.fetch()
        let pin = Pin(context: CoreDataStack.instance.context)
        pin.longitude = 30.0
        pin.latitude = 22.0
        pin.page = 1
        controller.add(model: pin)
        let item = controller.getItem(at: IndexPath(item: 0, section: 0))
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

struct PinViewModel: CoreDataMappable {
    let latitude: Double
    let longitude: Double
    let page: Int16
    
    init(model: Pin) {
        latitude = model.latitude
        longitude = model.longitude
        page = model.page
    }
}
