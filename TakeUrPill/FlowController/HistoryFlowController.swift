//
//  HistoryFlowController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 08/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryController {
    func dismiss()
}

final class HistoryFlowController: FlowController, HistoryController {
    private let configure: FlowConfigure

    required init(configure: FlowConfigure) {
        self.configure = configure
    }

    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "History") as? HistoryViewController else {
            return
        }

        configure(viewController)

        configure.navigationController?.pushViewController(viewController, animated: true)
    }

    func share<T>(data: T?) {}

    func dismiss() {
        configure.parent?.share(data: "")
    }

    // MARK: - Private
    private func configure(_ viewController: HistoryViewController) {
        if viewController.presenter == nil {
            viewController.presenter = HistoryPresenter()
            viewController.configure = ConfigureHistory(controller: self)
        }
    }
}
