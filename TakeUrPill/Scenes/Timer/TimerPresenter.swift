//
//  TimerPresenter.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 03/11/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

protocol TimerManageble {
    func getPillPicker() -> PillsPickerView?
    func getTimerPicker() -> DatePickerView?
}

struct TimerPresenter: TimerManageble {
    func getPillPicker() -> PillsPickerView? {
        return PillsPickerView().loadPickerView()
    }
    
    func getTimerPicker() -> DatePickerView? {
        return DatePickerView().loadPickerView()
    }
}
