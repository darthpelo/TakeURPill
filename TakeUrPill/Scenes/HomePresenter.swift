//
//  HomePresenter.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 07/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import IntentsUI
import Intents

protocol HomeManageble {
    func pillTook()
    func getLastPillName() -> String?
    func showUserHistory() -> Bool
    func showSiriViewController() -> INUIAddVoiceShortcutViewController?
}

struct HomePresenter: HomeManageble {
    private var storage: Storage

    init(_ storage: Storage = Storage()) {
        self.storage = storage
    }

    func pillTook() {
        guard let pillName = UserDefaults.standard.pillName else { return }
        guard let ammount = UserDefaults.standard.pillAmmount else { return }

        let pill = Pill(timestamp: Date().timeIntervalSince1970,
                        ammount: ammount,
                        name: pillName)
        if storage.store(pill) == false {
            logger("Failed to store pill")
        }
    }
    
    func getLastPillName() -> String? {
        if let lastPill = storage.getLastPill() {
            UserDefaults.standard.lastPill = storage.convertToData(lastPill)
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
            let lastPill = Storage().convertToPill(data) else { return nil }

        let intent = TakePillIntent()
        intent.ammount = lastPill.ammount as NSNumber
        intent.title = lastPill.name

        guard let short = INShortcut(intent: intent) else { return nil }

        return INUIAddVoiceShortcutViewController.init(shortcut: short)
    }


}
