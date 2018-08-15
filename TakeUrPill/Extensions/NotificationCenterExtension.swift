//
//  NotificationCenterExtension.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 08/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

extension NotificationCenter {
    func addUniqueObserver(_ observer: AnyObject,
                           selector: Selector,
                           name: NSNotification.Name,
                           object: AnyObject?) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
}
