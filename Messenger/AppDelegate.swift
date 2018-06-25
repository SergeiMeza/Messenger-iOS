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
        
        //  Realm objects initialization
        let config = Realm.Configuration(schemaVersion: 4, migrationBlock: { (migration, oldSchemaVersion) in
        })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        
        #if DEBUG
        print(log, NSHomeDirectory())
        
//        generateRandomUsersWithFirebaseDatabase()
//        generateRandomUsersWithFirebaseFirestore()
//        getUsersFromFirebaseDatabaseAndSaveInRealm()
//        getUsersFromFirebaseFirestoreAndSaveInRealm()
        
        #else
        print(log, "RELEASE")
        #endif
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let usersViewController = NavigationController.init(rootViewController: ViewControllerUsers.instantiate())
        usersViewController.tabBarItem.image = UIImage.init(named: "home")
        usersViewController.tabBarItem.imageInsets = .init(top: 4, left: 0, bottom: -4, right: 0)
        
        let chatsViewController = NavigationController.init(rootViewController: ViewControllerChats.instantiate())
        chatsViewController.tabBarItem.image = UIImage.init(named: "home")
        chatsViewController.tabBarItem.imageInsets = .init(top: 4, left: 0, bottom: -4, right: 0)
        
        let homeController = TabBarControllerHome()
        homeController.viewControllers = [usersViewController, chatsViewController]
        homeController.tabTitles = ["Home", "Chats"]
        
        window?.rootViewController = homeController
        
        return true
    }
    
   
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /*
     func generateRandomUsersWithFirebaseFirestore() {
     let database = Firestore.firestore()
     let randomGenerator = GKRandomDistribution.init(lowestValue: 0, highestValue: 4)
     for index in 1...100 {
     let user = database.document(DeviceConst.firebaseDatabaseRootURL.appendingPathComponent("USERS/active_users/\(index)").absoluteString)
     user.setData([
     "name":["David", "Rose", "Mary", "John", "Paul"][randomGenerator.nextInt()],
     "age": [13, 10, 18, 22, 24][randomGenerator.nextInt()],
     "gender": [0 , 1, 2, 3][randomGenerator.nextInt() % 4],
     "favorite_color": ["red", "blue", "orange", "pink", "yellow"][min(randomGenerator.nextInt(), 3)],
     "is_wizard": [true, false][randomGenerator.nextInt() % 2]
     ], options: .merge()) { (error) in
     if let error = error {
     print("Error adding document: \(error)")
     } else {
     print("Document added with ID: \(user.documentID)")
     }
     }
     }
     }
     */
    
    /**
     func getUsersFromFirebaseFirestoreAndSaveInRealm() {
     Service.users.getUsersFromFirestore(paginate: false) { result in
     switch result {
     case .error(let error):
     print(error)
     case .success(let users, _):
     DispatchQueue.init(label: "background", qos: DispatchQoS.background).async {
     autoreleasepool {
     let realm = try! Realm()
     try! realm.write {
     users.forEach {
     realm.add($0, update: true)
     }
     }
     }
     }
     }
     }
     }
     */
}

