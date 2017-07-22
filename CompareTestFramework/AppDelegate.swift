//
//  AppDelegate.swift
//  CompareTestFramework
//
//  Created by Shunya Yamashita on 2017/07/22.
//  Copyright © 2017年 shymst. All rights reserved.
//

import UIKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Twitter.sharedInstance().start(withConsumerKey: "ZwV1SZIfbqs1AELrNXiN3T4z6", consumerSecret: "xZoA9CGgaxp4cNAJz9NYJgEJ6enXchIUGlglOGTVBR7Ie8ocrf")

        let rootViewController = TimelineViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if Twitter.sharedInstance().application(app, open: url, options: options) {
            return true
        }
        return false
    }
}

