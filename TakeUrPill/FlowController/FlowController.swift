//
//  FlowController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 08/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

protocol FlowConfigure {
    var window: UIWindow? { get }
    var navigationController: UINavigationController? { get }
    var tabBarController: UITabBarController? { get }
    var parent: FlowController? { get }

    func popToRoot()
}

struct FlowConfigureImplementation: FlowConfigure {
    var window: UIWindow?
    weak var navigationController: UINavigationController?
    var tabBarController: UITabBarController?
    var parent: FlowController?

    init(window: UIWindow? = nil,
         navigationController: UINavigationController? = nil,
         tabBarController: UITabBarController? = nil,
         parent: FlowController? = nil) {
        self.window = window
        self.navigationController = navigationController
        self.tabBarController = tabBarController
        self.parent = parent
    }

    func popToRoot() {
        // Avoid that child flowcontroller push the newviewcontroller, without pop to the root before.
        if let count = self.navigationController?.viewControllers.count, count > 1 {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
}

protocol FlowController {
    init(configure: FlowConfigure)
    func start()
    func share<T>(data: T?)
}

struct FlowInizializer {
    func configure(_ window: UIWindow?) {
        let configure = FlowConfigureImplementation(window: window, navigationController: getNavigationController())
        let mainFlow = MainFlowController(configure: configure)
        mainFlow.start()
    }

    private func getNavigationController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navigationController = storyboard
            .instantiateViewController(withIdentifier: "Navigation") as? UINavigationController else {
                return nil
        }
        return navigationController
    }
}
