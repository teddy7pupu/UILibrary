//
//  AppDelegate.swift
//  UILibrary
//
//  Created by Teddy on 2021/7/31.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var door: UIWindow? = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        door = UIWindow()
        door?.makeKeyAndVisible()
        door?.rootViewController = UINavigationController.init(rootViewController: MainViewController())
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        return true
    }
}
