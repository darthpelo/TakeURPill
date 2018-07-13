//
//  LocalizableViews.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

class LocalisableUIButton: UIButton {

    @IBInspectable var localisedKey: String? {
        didSet {
            guard let key = localisedKey else { return }
            setTitle(NSLocalizedString(key, comment: ""), for: .normal)
        }
    }
}

class LocalisableUILabel: UILabel {

    @IBInspectable var localisedKey: String? {
        didSet {
            guard let key = localisedKey else { return }
            text = NSLocalizedString(key, comment: "")
        }
    }
}
