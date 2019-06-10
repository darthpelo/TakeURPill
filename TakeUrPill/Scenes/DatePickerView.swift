//
//  DatePickerView.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 18/11/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

class DatePickerView: UIView {

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var datePickerView: UIDatePicker!
    
    typealias DateSelected = (Date) -> Void
    
    private var presenter: DatePickerPresenter?
    private var parentView: UIView?
    private var dateSelected: DateSelected?
    private var cancelTapped: Cancelled?

    // MARK: - Public
    func loadPickerView(presenter: DatePickerPresenter = DatePickerPresenter()) -> DatePickerView? {
        //Get all views in the xib
        let allViewsInXibArray = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)
        
        //If you only have one view in the xib and you set it's class to MyView class
        guard let myView = allViewsInXibArray?.first as? DatePickerView else {
            return nil
        }
        
        myView.frame.origin.y = UIScreen.main.bounds.height
        myView.frame.size.width = UIScreen.main.bounds.width
        
        myView.presenter = presenter
        
        return myView
    }
    
    func configure(onView: UIView, onDone: @escaping DateSelected, onCancel: @escaping Cancelled) {
        guard let presenter = presenter else { return }
        
        datePickerView.maximumDate = Date()
        
        parentView = onView
        dateSelected = onDone
        cancelTapped = onCancel
        
        self.frame.origin.y = onView.frame.size.height
            
        let texts = presenter.getButtonsText()
        doneButton.setTitle(texts.done, for: .normal)
        cancelButton.setTitle(texts.cancel, for: .normal)
        
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
                            self.doneButton.isEnabled = false
                        } else {
                            self.frame.origin.y = height
                        }
        }) { [weak self] flag in
            guard let self = self else { return }
            self.isHidden = show == false ? true : false
        }
    }
    
    // MARK: - Private
    @IBAction private func valueChanged(_ sender: Any) {
        logger(datePickerView.date)
    }
    
    @IBAction private func cancelButtonTaper(_ sender: Any) {
        cancelTapped?()
    }
}

struct DatePickerPresenter {
    func getButtonsText() -> (done: String, cancel: String) {
        return ("Done", "Cancel")
    }
}
