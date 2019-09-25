//
//  HomePresenter.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 07/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import Intents
import IntentsUI

protocol HomeManageble {
    func pillTook(_ pill: PillType)
    func getLastPillName() -> String?
    func showUserHistory() -> Bool
    func showSiriViewController() -> INUIAddVoiceShortcutViewController?
}

struct HomePresenter: HomeManageble {
    private var storage: Storage

    init(_ storage: Storage = Storage()) {
        self.storage = storage
    }

    func pillTook(_ pill: PillType) {
        let pill = Pill(timestamp: Date().timeIntervalSince1970,
                        amount: pill.amount ?? 0,
                        name: pill.name)
        if storage.store(pill) == false {
            logger("Failed to store pill")
        }
    }
    
    func getLastPillName() -> String? {
        if let lastPill = storage.getLastPill() {
            UserDefaults.standard.lastPill = Convert.convertToData(lastPill)
            return lastPill.name
        } else {
            return nil
        }
    }

    func showUserHistory() -> Bool {
        if let session = UserDefaults.standard.userSession as? String,
            UserSession.History == UserSession(rawValue: session) {
            UserDefaults.standard.userSession = UserSession.Home.rawValue
            return true
        } else {
            return false
        }
    }

    func showSiriViewController() -> INUIAddVoiceShortcutViewController? {
        guard let data = UserDefaults.standard.lastPill,
            let lastPill = Convert.convertToPill(data) else { return nil }

        let intent = TakePillIntent()
        intent.amount = lastPill.amount as NSNumber
        intent.title = lastPill.name
        intent.suggestedInvocationPhrase = "\(lastPill.name) time"

        guard let short = INShortcut(intent: intent) else { return nil }

        return INUIAddVoiceShortcutViewController(shortcut: short)
    }
}
