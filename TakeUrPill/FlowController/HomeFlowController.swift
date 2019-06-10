//
//  HomeFlowController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 08/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

protocol HomeController {
    func showHistory()
    func showTimer()
}

final class HomeFlowController: FlowController, HomeController {
    private let configure: FlowConfigure
    private var historyFlow: FlowController?
    private var timerFlow: FlowController?

    required init(configure: FlowConfigure) {
        self.configure = configure
    }

    deinit {
        historyFlow = nil
        timerFlow = nil
    }

    func start() {
        if let navigationController = configure.navigationController {
            configure(navigationController)

            guard let viewController = configure.navigationController?.viewControllers.first as? HomeViewController else { return }

            configure(viewController)
        }
    }

    // Optional FlowController function
    func share<T>(data: T?) {
        if let data = data as? String, data.isEmpty {
            configure.window?.rootViewController?.dismiss(animated: true, completion: nil)
            historyFlow = nil
        }
    }

    func showHistory() {
        configure.popToRoot()
        
        let historyConf = FlowConfigureImplementation(window: configure.window,
                                                      navigationController: configure.navigationController,
                                                      parent: self)
        historyFlow = HistoryFlowController(configure: historyConf)
        historyFlow?.start()
    }

    func showTimer() {
        configure.popToRoot()
        
        let timerConf = FlowConfigureImplementation(window: configure.window,
                                                      navigationController: configure.navigationController,
                                                      parent: self)
        timerFlow = TimerFlowController(configure: timerConf)
        timerFlow?.start()
    }
    // MARK: - Private

    private func configure(_ navigationController: UINavigationController) {
        if let frame = configure.window?.bounds {
            navigationController.view.frame = frame
        } else {
            return
        }

        configure.window?.rootViewController = navigationController
        configure.window?.makeKeyAndVisible()
    }

    private func configure(_ viewController: HomeViewController) {
        if viewController.presenter == nil {
            viewController.presenter = HomePresenter()
            viewController.configure = ConfigureHome(controller: self)
        }
    }
}
