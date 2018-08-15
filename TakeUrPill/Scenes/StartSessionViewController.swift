//
//  StartSessionViewController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

final class StartSessionViewController: BaseViewController {

    @IBOutlet weak var pillNameTextField: UITextField!
    @IBOutlet weak var ammountTextField: UITextField!

    private var name: String?
    private var ammount: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Settings"
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let name = self.name else {
            let alertView = UIAlertController(title: nil, message: "Name must be fill", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertView, animated: true, completion: nil)
            return
        }

        UserDefaults.standard.pillName = name
        UserDefaults.standard.pillAmmount = Int(ammount ?? "1")

        self.dismiss(animated: true, completion: nil)
    }
}

extension StartSessionViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == pillNameTextField, let text = textField.text {
            name = text + string
        } else if textField == ammountTextField, let text = textField.text {
            ammount = text + string
        }
        return true
    }
}
