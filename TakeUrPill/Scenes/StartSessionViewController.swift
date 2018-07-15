//
//  StartSessionViewController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

class StartSessionViewController: UIViewController {

    @IBOutlet weak var pillNameTextField: UITextField!
    @IBOutlet weak var ammountTextField: UITextField!

    private var name: String?
    private var ammount: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        let userDefault = UserDefaults.standard

        userDefault.set(name, forKey: "pill.name")
        userDefault.set(Int(ammount ?? "1"  ), forKey: "pill.ammount")

        self.dismiss(animated: true, completion: nil)
    }
}

extension StartSessionViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == pillNameTextField {
            name = textField.text! + string
        } else if textField == ammountTextField {
            ammount = textField.text! + string
        }
        return true
    }
}
