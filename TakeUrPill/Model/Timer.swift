//
//  Timer.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 18/11/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

struct Timer: Codable {
    let time: TimeInterval
    let pill: PillType
}

extension Timer: Equatable {
    static func == (lhs: Timer, rhs: Timer) -> Bool {
        return lhs.time == rhs.time && lhs.pill == rhs.pill
    }
}
