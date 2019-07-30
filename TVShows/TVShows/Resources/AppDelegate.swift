//
//  AppDelegate.swift
//  TVShows
//
//  Created by Borna on 04/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import KeychainAccess
import Alamofire
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let initialVCIdentifier = "initialNavigationController"
    private let loginVCIdentifier = "LoginViewController"
    private let userCredentials = UserCredentials.shared
    private let storyboard = UIStoryboard(name: "Login", bundle: nil)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if let user = userCredentials.loggedUser() {
            showHomeVC(user: user)
        } else {
            showLoginVC()
        }
        
        return true
    }
    
    private func showLoginVC() {
        if let initialNavigationController = storyboard.instantiateViewController(withIdentifier: initialVCIdentifier) as? UINavigationController {
            let loginViewController = storyboard.instantiateViewController(withIdentifier: loginVCIdentifier)
            initialNavigationController.viewControllers = [loginViewController]
            window?.rootViewController = initialNavigationController
            window?.makeKeyAndVisible()
        }
    }
    
    private func showHomeVC(user:(String,String)) {
        if let initialNavigationController = storyboard.instantiateViewController(withIdentifier: initialVCIdentifier) as? UINavigationController {
         
            if let homeCollectionViewController = storyboard.instantiateViewController(withIdentifier: "HomeCollectionViewController") as? HomeCollectionViewController {
                
                homeCollectionViewController.userFromKeychain = user
                
                initialNavigationController.setViewControllers([homeCollectionViewController], animated: false)
                window?.rootViewController = initialNavigationController
                window?.makeKeyAndVisible()
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

