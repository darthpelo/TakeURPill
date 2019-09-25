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
    var amount: Int
    var name: String
}

extension Pill: Equatable {
    static func == (lhs: Pill, rhs: Pill) -> Bool {
        return
            lhs.timestamp == rhs.timestamp &&
                lhs.amount == rhs.amount &&
                lhs.name == rhs.name
    }
}

@available(iOS 12.0, *)
extension Pill {
    var intent: TakePillIntent {
        let takePillIntent = TakePillIntent()
        takePillIntent.amount = self.amount as NSNumber
        takePillIntent.title = self.name
        return takePillIntent
    }

    init?(from intent: TakePillIntent) {
        guard let amount = intent.amount as? Int,
            let name = intent.title else {
                return nil
        }

        self.init(timestamp: Date().timeIntervalSince1970,
                  amount: amount,
                  name: name)
    }
}

struct PillType: Codable {
    var amount: Int?
    var name: String
}

extension PillType: Equatable {
    static func == (lhs: PillType, rhs: PillType) -> Bool {
        return
            lhs.amount == rhs.amount &&
                lhs.name == rhs.name
    }
}
