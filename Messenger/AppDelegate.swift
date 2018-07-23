//
//  AppDelegate.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import RealmSwift

let log = "LOG:"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let theURL = Bundle.main.url(forResource:"cafe", withExtension: "mov")
        
        let vc = HeroViewController(videoUrl: theURL)
        let navController = TransparentNavigationController.init(rootViewController: vc)
        
        window?.rootViewController = navController
        
        return true
    }
}

