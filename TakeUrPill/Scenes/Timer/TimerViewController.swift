//
//  TimerViewController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 03/11/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

struct ConfigureTimer {
}

class TimerViewController: UIViewController {
    @IBOutlet private weak var informLabel: UILabel!
    
    var presenter: TimerManageble?
    var configure: ConfigureTimer?
    
    private var pickerView: PillsPickerView?
    private var timerPickerView: DatePickerView? {
        guard let timerPickerView = presenter?.getTimerPicker() else { return nil }
        
        timerPickerView.configure(onView: self.view, onDone: { date in
            timerPickerView.isTo(show: false)
        }) {
            timerPickerView.isTo(show: false)
        }
        return timerPickerView
    }
    
    // MARK: - Public
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private
    @IBAction private func pillButtonPressed(_ sender: Any) {
        configurePickerView()
        pickerView?.isTo(show: true)
    }
    
    @IBAction private func timerButtonPressed(_ sender: Any) {
        timerPickerView?.isTo(show: true)
    }
    
    private func configurePickerView() {
        if pickerView == nil {
            guard let pickerView = presenter?.getPillPicker() else { return }
            
            pickerView.configure(onView: self.view,
                                  onDone: { [weak self] selectedPillType in
                                    guard let self = self else { return }
                                    
                                    self.pickerView?.isTo(show: false)
                                    self.pickerView = nil
                }, onCancel: { [weak self] in
                    guard let self = self else { return }
                    
                    self.pickerView?.isTo(show: false)
                    self.pickerView = nil
            })
            
            self.pickerView = pickerView
        }
    }
}
