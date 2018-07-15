//
//  AppDelegate.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        switch userActivity.activityType {
        case "com.mobiquityinc.demo.TakeUrPill.takepill":
            print("com.mobiquityinc.demo.TakeUrPill.takepill")
            return true
        case "TakePillIntent":
            if #available(iOS 12.0, *) {
                guard let intent = userActivity.interaction?.intent as? TakePillIntent,
                    let model = Pill(from: intent) else {
                        return false
                }
                let storage = Storage()
                return storage.store(model)
            } else {
                return false
            }
        default:()
        }

        return false
    }
}
