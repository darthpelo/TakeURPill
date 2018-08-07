//
//  HomeViewController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Intents
import IntentsUI
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var takePillButton: UIButton!
    @IBOutlet weak var siriButtonContainer: UIView!
    @IBOutlet weak var intentSuggestionLabel: UILabel!
    
    private var siriVC: INUIAddVoiceShortcutViewController?
    
    lazy var notificationCenter: NotificationCenter = {
        NotificationCenter.default
    }()
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationCenter.addObserver(self,
                                       selector: #selector(checkUserSession),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activitySetup(ActivityInformation(activityType: "com.mobiquityinc.demo.TakeUrPill.takepill",
                                          activityTitle: "I took my pill"))
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowStartSession", sender: self)
    }
    
    @IBAction func takePillButtonPressed(_ sender: Any) {
        pillTook()
        
        setupAddSiri()
    }
    
    @IBAction func historyButtonPressed(_ sender: Any) {
        showHistory()
    }
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
        //nothing goes here
    }
    
    @objc func checkUserSession() {
        if let session = UserDefaults.standard.userSession as? String,
            UserSession.History == UserSession(rawValue: session) {
            showHistory()
            UserDefaults.standard.userSession = UserSession.Home.rawValue
        }
    }
    
    @objc func showSiri() {
        guard let data = UserDefaults.standard.lastPill,
            let lastPill = Storage().convertToPill(data) else { return }
        
        let intent = TakePillIntent()
        intent.ammount = lastPill.ammount as NSNumber
        intent.title = lastPill.name
        
        guard let short = INShortcut(intent: intent) else { return }
        
        siriVC = INUIAddVoiceShortcutViewController.init(shortcut: short)
        
        if let siriVC = siriVC {
            siriVC.delegate = self
            self.present(siriVC, animated: true, completion: nil)
        }
    }
}

extension HomeViewController {
    
    private func setupAddSiri() {
        let storage = Storage()
        
        if let lastPill = storage.getLastPill() {
            UserDefaults.standard.lastPill = storage.convertToData(lastPill)
            
            let siriButton: INUIAddVoiceShortcutButton = INUIAddVoiceShortcutButton.init(style: INUIAddVoiceShortcutButtonStyle.whiteOutline)
            
            siriButton.frame.size = self.siriButtonContainer.frame.size
            
            siriButtonContainer.addSubview(siriButton)
            siriButtonContainer.sizeToFit()
            
            siriButton.addTarget(self, action: #selector(showSiri), for: .touchUpInside)
            
            siriButtonContainer.isHidden = false

            let text = String(format: NSLocalizedString("home.siri.intent.suggestion", comment: ""), lastPill.name!)
            intentSuggestionLabel.text = text
        } else {
            hideSiriElements()
        }
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
        self.performSegue(withIdentifier: "ShowHistory", sender: self)
    }
    
    private func pillTook() {
        let storage = Storage()
        
        let pillName = UserDefaults.standard.object(forKey: "pill.name") as? String
        let ammount = UserDefaults.standard.integer(forKey: "pill.ammount")
        
        let pill = Pill(timestamp: Date().timeIntervalSince1970,
                        ammount: ammount,
                        name: pillName)
        storage.store(pill)
    }
}

extension HomeViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
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
