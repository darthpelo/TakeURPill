//
//  TimerFlowController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 03/11/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

protocol TimerController {}

final class TimerFlowController: FlowController, TimerController {
    private let configure: FlowConfigure
    
    required init(configure: FlowConfigure) {
        self.configure = configure
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "Timer") as? TimerViewController else {
            return
        }
        
        configure(viewController)
        
        configure.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func share<T>(data: T?) {}
    
    // MARK: - Private
    private func configure(_ viewController: TimerViewController) {
        if viewController.presenter == nil {
            viewController.presenter = TimerPresenter()
            viewController.configure = ConfigureTimer()
        }
    }
}
