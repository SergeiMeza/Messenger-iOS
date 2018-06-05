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
import GameKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(NSHomeDirectory())
        
        FirebaseApp.configure()
        
//        generateRandomUsersWithFirebaseDatabase()
//        generateRandomUsersWithFirebaseFirestore()
        
        //  Realm objects initialization
        let config = Realm.Configuration(schemaVersion: 0, migrationBlock: { (migration, oldSchemaVersion) in
            
        })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        
//        getUsersFromFirebaseDatabaseAndSaveInRealm()
//        getUsersFromFirebaseFirestoreAndSaveInRealm()
        
        window = UIWindow()
        window?.makeKeyAndVisible()
//        window?.rootViewController = ViewController()
        let homeViewController = UINavigationController.init(rootViewController: ViewControllerUsers.instantiate())
        homeViewController.tabBarItem.title = "Home"
        homeViewController.tabBarItem.image = UIImage.init(named: "home")
        let tabBarController = UITabBarController.init()
        tabBarController.viewControllers = [homeViewController]
        window?.rootViewController = tabBarController
        
        return true
    }
    
    func generateRandomUsersWithFirebaseDatabase() {
            let randomGenerator = GKRandomDistribution.init(lowestValue: 0, highestValue: 4)
            for _ in 1...100 {
                let user = FirebaseObject.init(path: "USER")
                user[DeviceConst.object_id] = FirebaseObject.autoId()
                user["name"] = ["David", "Rose", "Mary", "John", "Paul"][randomGenerator.nextInt()]
                user["age"] = [13, 10, 18, 22, 24][randomGenerator.nextInt()]
                user["gender"] = [0 , 1, 2, 3][randomGenerator.nextInt() % 4]
                user["favorite_color"] = ["red", "blue", "orange", "pink", "yellow"][min(randomGenerator.nextInt(), 3)]
                user["is_wizard"] = [true, false][randomGenerator.nextInt() % 2]
                user.saveInBackground()
            }
    }
    
    func generateRandomUsersWithFirebaseFirestore() {
        let database = Firestore.firestore()
        var reference: DocumentReference!
        let randomGenerator = GKRandomDistribution.init(lowestValue: 0, highestValue: 4)
        for _ in 1...100 {
            reference = database.collection(DeviceConst.firebaseDatabaseRootURL.appendingPathComponent("USERS/active_users/").absoluteString).addDocument(data: [
                "name":["David", "Rose", "Mary", "John", "Paul"][randomGenerator.nextInt()],
                 "age": [13, 10, 18, 22, 24][randomGenerator.nextInt()],
                 "gender": [0 , 1, 2, 3][randomGenerator.nextInt() % 4],
                 "favorite_color": ["red", "blue", "orange", "pink", "yellow"][min(randomGenerator.nextInt(), 3)],
                 "is_wizard": [true, false][randomGenerator.nextInt() % 2]
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(reference.documentID)")
                }
            }
        }
    }
    
    func getUsersFromFirebaseDatabaseAndSaveInRealm() {
        Service.users.getUsersFromFirebase { result in
            switch result {
            case .error(let error):
                print(error)
            case .success(let users):
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


}

