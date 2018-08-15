//
//  HistoryPresenter.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 07/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import IntentsUI

protocol HistoryManageable {
    var information: SiriService.ActivityInformation { get }

    func eraseUserHistory() -> Bool
    func getUserHistory() -> [Pill]
    func showSiriViewController() -> INUIAddVoiceShortcutViewController?
}

struct HistoryPresenter: HistoryManageable {
    let information = SiriService.ActivityInformation(activityType: "com.alessioroberto.TakeUrPill.history",
                                                      activityTitle: NSLocalizedString("activity.history", comment: ""),
                                                      activitySuggestedInvocation: NSLocalizedString("activity.history.suggestion", comment: ""))
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

    func showSiriViewController() -> INUIAddVoiceShortcutViewController? {
        return INUIAddVoiceShortcutViewController(shortcut: INShortcut(userActivity: SiriService.activitySetup(information)))
    }
}
