//
//  PillsPickerView.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 18/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

typealias Cancelled = (() -> Void)

class PillsPickerView: UIView {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var pills: [PillType] = []
    private var pill: PillType?
    
    typealias PillSelected = (PillType) -> Void
    
    private var pillSelected: PillSelected?
    private var cancelTapped: Cancelled?
    
    private var parentView: UIView?
    
    private var presenter: PillsPickerPresenter?
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        if let pill = pill {
            pillSelected?(pill)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        cancelTapped?()
    }
    
    func loadPickerView(presenter: PillsPickerPresenter = PillsPickerPresenter()) -> PillsPickerView? {
        //Get all views in the xib
        let allViewsInXibArray = Bundle.main.loadNibNamed("PillsPickerView", owner: self, options: nil)
        
        //If you only have one view in the xib and you set it's class to MyView class
        guard let myView = allViewsInXibArray?.first as? PillsPickerView else {
            return nil
        }
        
        myView.frame.origin.y = UIScreen.main.bounds.height
        myView.frame.size.width = UIScreen.main.bounds.width
        
        myView.presenter = presenter
        
        return myView
    }
    
    func configure(onView: UIView, onDone: @escaping PillSelected, onCancel: @escaping Cancelled) {
        pillSelected = onDone
        cancelTapped = onCancel
        parentView = onView
        pickerView.dataSource = self
        pickerView.delegate = self
        
        self.frame.origin.y = onView.frame.size.height
        
        guard let presenter = presenter else { return }
        
        let texts = presenter.getButtonsText()
        doneButton.setTitle(texts.done, for: .normal)
        cancelButton.setTitle(texts.cancel, for: .normal)
        
        loadPills()
        
        isHidden = true
        
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func isTo(show: Bool) {
        guard let height = parentView?.frame.size.height else {
            return
        }
        
        UIView.animate(withDuration: 0.3,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        if show {
                            self.isHidden = false
                            self.frame.origin.y = height - self.frame.size.height
                            if self.pills.isEmpty {
                                self.doneButton.isEnabled = false
                            } else {
                                self.doneButton.isEnabled = true
                            }
                        } else {
                            self.frame.origin.y = height
                        }
        }) { [weak self] flag in
            guard let self = self else { return }
            self.isHidden = show == false ? true : false
        }
    }
    
    private func loadPills() {
        pills = presenter?.getUserHistory() ?? []
        
        pill = pills.isEmpty ? nil : pills[0]
    }
}

extension PillsPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pills.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let pillType = pills[row]
        return "\(pillType.name) - \(pillType.ammount)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pill = pills[row]
    }
}

struct PillsPickerPresenter {
    private var storage: Storage?
    
    init(storage: Storage = Storage()) {
        self.storage = storage
    }
    
    func getButtonsText() -> (done: String, cancel: String) {
        return ("Done", "Cancel")
    }
    
    func getUserHistory() -> [PillType] {
        do {
            guard let data = try storage?.readTypes() else { return [] }
            let decoder = JSONDecoder()
            let list = try decoder.decode([PillType].self, from: data)
            return list.sorted { $0.name > $1.name }
        } catch {
            return []
        }
    }
}
