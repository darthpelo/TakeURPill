//
//  UserDefaults.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 29/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

extension UserDefaults {
    var userSession: Any? {
        get { return object(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    var userHistory: Data? {
        get { return data(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    var lastPill: Data? {
        get { return data(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }

    var userIntentsHistory: Data? {
        get { return data(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
}

