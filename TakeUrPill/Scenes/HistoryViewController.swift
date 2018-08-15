//
//  HistoryViewController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 14/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import IntentsUI
import UIKit

struct ConfigureHistory {
    let controller: HistoryController
}

final class HistoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewContainer: UIView!
    
    var presenter: HistoryManageable?
    var configure: ConfigureHistory?

    private var siriVC: INUIAddVoiceShortcutViewController?
    private var list: [Pill] = []
    private lazy var notification = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        notification.addUniqueObserver(self,
                                       selector: #selector(reload),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)

        self.title = NSLocalizedString("history.title", comment: "")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let history = presenter?.getUserHistory() {
            list = history
        }

        let siriButton: INUIAddVoiceShortcutButton = INUIAddVoiceShortcutButton(style: INUIAddVoiceShortcutButtonStyle.white)

        siriButton.frame.size = self.viewContainer.frame.size
        siriButton.addTarget(self, action: #selector(showSiri), for: .touchUpInside)

        viewContainer.addSubview(siriButton)
        viewContainer.sizeToFit()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let information = presenter?.information {
            activitySetup(information)
        }
    }

    deinit {
        notification.removeObserver(self)
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        configure?.controller.dismiss()
    }

    @IBAction func eraseHistoryButtonPressed(_ sender: Any) {
        if let presenter = presenter, presenter.eraseUserHistory() {
            list.removeAll()
            tableView.reloadData()
        } else {
            logger("Error erasing file")
        }
    }

    @objc func reload() {
        if let history = presenter?.getUserHistory() {
            list = history
            tableView.reloadData()
        }
    }

    @objc func showSiri() {
        siriVC = presenter?.showSiriViewController()

        if let siriVC = siriVC {
            siriVC.delegate = self
            self.present(siriVC, animated: true, completion: nil)
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)

        let pill = list[indexPath.row]

        cell.textLabel?.text = pill.name
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: Date(timeIntervalSince1970: pill.timestamp),
                                                                   dateStyle: .medium,
                                                                   timeStyle: .medium)

        return cell
    }
}

extension HistoryViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                        didFinishWith voiceShortcut: INVoiceShortcut?,
                                        error: Error?) {
        if let error = error {
            logger(error)
        } else {
            logger(voiceShortcut?.invocationPhrase)
        }
        siriVC?.dismiss(animated: true, completion: nil)
    }

    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        logger("no shortcut created")
        siriVC?.dismiss(animated: true, completion: nil)
    }
}
