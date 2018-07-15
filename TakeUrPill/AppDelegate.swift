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
        case "TakePillIntent":
            if #available(iOS 12.0, *) {
                guard let intent = userActivity.interaction?.intent as? TakePillIntent,
                    let model = Pill(from: intent) else {
                        return false
                }
                return store(model)
            } else {
                return false
            }
        default:()
        }

        return false
    }
}

extension AppDelegate {
    func store(_ pill: Pill) -> Bool {
        let storage = Storage()
        do {
            let json = try storage.readHistory()
            var list = storage.convertToPills(json)

            if list != nil {
                list!.append(pill)
                if let newJson = storage.convertToData(list!) {
                    try storage.saveHistory(newJson)
                }
            }
        } catch let error as HistoryError {
            if error == .fileEmpty {
                if let newJson = storage.convertToData([pill]) {
                    try? storage.saveHistory(newJson)
                }
            } else {
                print("\(error.localizedDescription)")
                return false
            }
        } catch {
            print("Read Error")
            return false
        }
        return true
    }
}
