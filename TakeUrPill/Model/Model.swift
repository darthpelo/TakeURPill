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
    var name: String?
}

extension Pill: Equatable {
    static func == (lhs: Pill, rhs: Pill) -> Bool {
        return
            lhs.timestamp == rhs.timestamp &&
                lhs.ammount == rhs.ammount &&
                lhs.name == rhs.name
    }
}
