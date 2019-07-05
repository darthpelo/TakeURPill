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
    @IBOutlet weak var tableView: UITableView!
    private var dataSource: TableViewDataSource<PillType>?

    private var name: String?
    private var ammount: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Settings"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        pillsDidLoad(self.getUserHistory())
        tableView.reloadData()
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let name = self.name else {
            let alertView = UIAlertController(title: nil,
                                              message: NSLocalizedString("startSession.alert.name", comment: ""),
                                              preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertView, animated: true, completion: nil)
            return
        }

        UserDefaults.standard.pillName = name
        UserDefaults.standard.pillAmmount = Int(ammount ?? "0")

        _ = Storage().store(PillType(ammount: Int(ammount ?? "0"), name: name))

        self.navigationController?.popToRootViewController(animated: true)
    }

    private func pillsDidLoad(_ pills: [PillType]) {
        dataSource = .make(for: pills)
        tableView.dataSource = dataSource
        dataSource?.delegate = self
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

extension String {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension StartSessionViewController {
    func eraseUserHistory() -> Bool {
        return Storage().deleteTypes()
    }

    func getUserHistory() -> [PillType] {
        var list: [PillType] = []

        do {
            let data = try Storage().readTypes()
            let decoder = JSONDecoder()
            list = try decoder.decode([PillType].self, from: data)
        } catch {}

        return list.sorted { $0.name > $1.name }
    }
    
    func removePillType(at: Int) {
        Storage().deleteType(at: at)
    }
}

extension StartSessionViewController: RowUpdateProtocol {
    func removeModel(at: Int) {
        self.removePillType(at: at)
    }
}
