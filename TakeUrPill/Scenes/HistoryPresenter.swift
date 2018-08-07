//
//  HistoryPresenter.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 07/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

protocol HistoryManageable {
    func eraseUserHistory() -> Bool
    func getUserHistory() -> [Pill]
}

struct HistoryPresenter: HistoryManageable {
    private var storage: Storage

    init(_ storage: Storage = Storage()) {
        self.storage = storage
    }

    func eraseUserHistory() -> Bool {
        return storage.deleteHistory()
    }

    func getUserHistory() -> [Pill] {
        var list: [Pill] = []

        do {
            let data = try storage.readHistory()
            let decoder = JSONDecoder()
            list = try decoder.decode([Pill].self, from: data)
        } catch {}

        return list.sorted { $0.timestamp > $1.timestamp }
    }


}
