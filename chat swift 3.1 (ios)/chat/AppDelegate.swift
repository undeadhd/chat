//
//  AppDelegate.swift
//  chat
//
//  Created by Павел Гречихин on 30.06.17.
//  Copyright © 2017 Павел Гречихин. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        SocketManager.sharedInstance
        
        let realm = try! Realm()
        if realm.objects(UserData.self).count > 0 {
            request("http://127.0.0.1:8080/auth/", method: .post, headers: ["log": realm.objects(UserData.self)[0].login, "password" : realm.objects(UserData.self)[0].password]).responseJSON { response in
                
                if response.response == nil {
                    print("Сервер авторизации отключен")
                } else {
                    let res = JSON(response.result.value!)
                    print(res["token"])
                    let ident = UserData()
                    ident.userID = "1"
                    ident.login = realm.objects(UserData.self)[0].login
                    ident.password = realm.objects(UserData.self)[0].password
                    ident.token = res["token"].string!
                    try! realm.write {
                        realm.add(ident, update: true)
                    }
                }
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let inVC = storyboard.instantiateViewController(withIdentifier: "navContr")
            self.window?.rootViewController = inVC
            self.window?.makeKeyAndVisible()
            SocketManager.sharedInstance.establishConnection()
            print("авторизуемся")
        }
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
        SocketManager.sharedInstance.closeConnection()
    }
    

}

