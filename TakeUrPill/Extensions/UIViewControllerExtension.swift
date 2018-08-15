//
//  UIViewControllerExtension.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 06/08/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func activitySetup(_ information: SiriService.ActivityInformation) {
        // make this activity active for the current view controller – this is what Siri will restore when the activity is triggered
        self.userActivity = SiriService.activitySetup(information)
    }
}

extension UIViewController {
    public func dch_checkDeallocation(afterDelay delay: TimeInterval = 2.0) {
        let rootParentViewController = dchRootParentViewController

        // We don’t check `isBeingDismissed` simply on this view controller because it’s common
        // to wrap a view controller in another view controller (e.g. in UINavigationController)
        // and present the wrapping view controller instead.
        if isMovingFromParent || rootParentViewController.isBeingDismissed {
            let typeOfSelf = type(of: self)
            let disappearanceSource: String = isMovingFromParent ? "removed from its parent" : "dismissed"

            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [weak self] in
                if self != nil {
                    logger("\(typeOfSelf) not deallocated after being \(disappearanceSource)")
                } else {
                    logger("\(typeOfSelf) deallocated after being \(disappearanceSource)")
                }
            })
        }
    }

    private var dchRootParentViewController: UIViewController {
        var root = self

        while let parent = root.parent {
            root = parent
        }

        return root
    }
}

class BaseViewController: UIViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        dch_checkDeallocation()
    }
}
