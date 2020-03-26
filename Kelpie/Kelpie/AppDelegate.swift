//
//  AppDelegate.swift
//  Kelpie
//
//  Created by Elliott Kipper on 9/3/19.
//  Copyright © 2019 Kip. All rights reserved.
//

import RealmSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - App Lifecycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.preparePreparablesAtAppLaunch()
        self.themeApp()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
}

fileprivate extension AppDelegate {
    
     func preparePreparablesAtAppLaunch() {
        let preparables: [LaunchPreparable.Type] = [Realm.self, SearchTarget.self]
        preparables.forEach {
            $0.prepareAtAppLaunch()
        }
    }
    
    func themeApp() {
        self.window?.tintColor = UIColor.kelpieAccent
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.toolbarButton], for: .normal)
        UIButton.appearance().tintColor = .toolbarButton
    }
    
}
