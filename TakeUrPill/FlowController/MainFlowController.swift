//
//  MainFlowController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 08/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

final class MainFlowController: FlowController {
    let configure: FlowConfigure

    private var homeFlow: HomeFlowController?

    private lazy var notificationCenter: NotificationCenter = {
        NotificationCenter.default
    }()

    required init(configure: FlowConfigure) {
        self.configure = configure
    }

    deinit {
        homeFlow = nil
        notificationCenter.removeObserver(self)
    }

    func start() {
        let homeConf = FlowConfigureImplementation(window: configure.window,
                                                   navigationController: configure.navigationController,
                                                   tabBarController: nil,
                                                   parent: self)

        homeFlow = HomeFlowController(configure: homeConf)
        homeFlow?.start()
    }

    func share<T>(data: T?) {

    }
}
