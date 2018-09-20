//
//  HomeViewController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import IntentsUI
import UIKit

struct ConfigureHome {
    let controller: HomeController
}

final class HomeViewController: BaseViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var takePillButton: UIButton!
    @IBOutlet weak var siriButtonContainer: UIView!
    @IBOutlet weak var intentSuggestionLabel: UILabel!
    
    private var siriVC: INUIAddVoiceShortcutViewController?
    
    var presenter: HomeManageble?
    var configure: ConfigureHome?
    
    private var pickerView: PillsPickerView?
    
    lazy var notificationCenter: NotificationCenter = {
        NotificationCenter.default
    }()
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addUniqueObserver(self,
                                             selector: #selector(checkUserSession),
                                             name: NSNotification
                                                .Name(rawValue: "com.alessioroberto.TakeUrPill.history"),
                                             object: nil)

        self.title = NSLocalizedString("home.title", comment: "")
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
    }
    
    @IBAction func takePillButtonPressed(_ sender: Any) {
        configurePickerView()
        pickerView?.isTo(show: true)
    }
    
    @IBAction func historyButtonPressed(_ sender: Any) {
        showHistory()
    }
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
        //nothing goes here
    }
    
    @objc func checkUserSession() {
        userSession()
    }
    
    @objc func showSiri() {
        siriVC = presenter?.showSiriViewController()
        
        if let siriVC = siriVC {
            siriVC.delegate = self
            self.present(siriVC, animated: true, completion: nil)
        }
    }
    
    private func configurePickerView() {
        if pickerView == nil {
            pickerView = PillsPickerView().loadPickerView()
            
            pickerView?.configure(onView: self.view,
                                  onDone: { [weak self] selectedPillType in
                                    guard let self = self else { return }
                                    
                                    self.pillTook(selectedPillType)
                                    self.setupAddSiri()
                                    
                                    self.pickerView?.isTo(show: false)
                                    self.pickerView = nil
                }, onCancel: { [weak self] in
                    guard let self = self else { return }
                    self.pickerView?.isTo(show: false)
                    self.pickerView = nil
            })
        }
    }
}

extension HomeViewController {
    private func userSession() {
        if let presenter = presenter, presenter.showUserHistory() {
            showHistory()
        }
    }
    
    private func setupAddSiri() {
        if let pillName = presenter?.getLastPillName() {
            showSiriElements(pillName)
        } else {
            hideSiriElements()
        }
    }
    
    private func showSiriElements(_ pillName: String) {
        let siriButton: INUIAddVoiceShortcutButton = INUIAddVoiceShortcutButton(style: INUIAddVoiceShortcutButtonStyle.whiteOutline)
        
        siriButton.frame.size = self.siriButtonContainer.frame.size
        
        siriButtonContainer.addSubview(siriButton)
        siriButtonContainer.sizeToFit()
        
        siriButton.addTarget(self, action: #selector(showSiri), for: .touchUpInside)
        
        siriButtonContainer.isHidden = false
        
        intentSuggestionLabel.text = String(format: NSLocalizedString("home.siri.intent.suggestion", comment: ""),
                                            pillName)
    }
    
    private func hideSiriElements() {
        let subviews = siriButtonContainer.subviews
        
        if let button = subviews.first, subviews.count == 1 {
            button.removeFromSuperview()
        }
        
        intentSuggestionLabel.text = nil
        
        siriButtonContainer.isHidden = true
        intentSuggestionLabel.isEnabled = true
    }
    
    private func showHistory() {
        configure?.controller.show()
    }
    
    private func pillTook(_ pill: PillType) {
        presenter?.pillTook(pill)
    }
}

extension HomeViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                        didFinishWith voiceShortcut: INVoiceShortcut?,
                                        error: Error?) {
        if let error = error {
            logger(error)
        } else {
            logger(voiceShortcut?.invocationPhrase)
            hideSiriElements()
        }
        siriVC?.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        logger("no shortcut created")
        siriVC?.dismiss(animated: true, completion: nil)
    }
}
