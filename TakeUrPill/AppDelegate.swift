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

        setupInitialScreen()
        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return handle(userAcitivity: userActivity)
    }

    // MARK: - Private
    private func handle(userAcitivity activity: NSUserActivity) -> Bool {
        switch activity.activityType {
        case "com.alessioroberto.TakeUrPill.takepill":
            UserDefaults.standard.userSession = UserSession.Home.rawValue
            return true
        case "com.alessioroberto.TakeUrPill.history":
            UserDefaults.standard.userSession = UserSession.History.rawValue
            let notificationName = Notification.Name(rawValue: "com.alessioroberto.TakeUrPill.history")
            NotificationCenter.default.post(name: notificationName, object: nil)
            return true
        case "TakePillIntent":
            guard let intent = activity.interaction?.intent as? TakePillIntent,
                let model = Pill(from: intent) else {
                    return false
            }
            let storage = Storage()
            if storage.store(model) {
                return true
            }
            return false
        default:()
        }
        return false
    }

    private func setupInitialScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        FlowInizializer().configure(window)
    }
}
