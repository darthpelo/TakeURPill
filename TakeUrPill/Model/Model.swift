//
//  Model.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

struct Pill: Codable {
    var timestamp: TimeInterval
    var ammount: Int
    var name: String
}

extension Pill: Equatable {
    static func == (lhs: Pill, rhs: Pill) -> Bool {
        return
            lhs.timestamp == rhs.timestamp &&
                lhs.ammount == rhs.ammount &&
                lhs.name == rhs.name
    }
}

@available(iOS 12.0, *)
extension Pill {
    var intent: TakePillIntent {
        let takePillIntent = TakePillIntent()
        takePillIntent.ammount = self.ammount as NSNumber
        takePillIntent.title = self.name
        return takePillIntent
    }

    init?(from intent: TakePillIntent) {
        guard let ammount = intent.ammount as? Int,
            let name = intent.title else {
                return nil
        }

        self.init(timestamp: Date().timeIntervalSince1970,
                  ammount: ammount,
                  name: name)
    }
}
