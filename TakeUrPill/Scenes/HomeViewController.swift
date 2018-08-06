//
//  HomeViewController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Intents
import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var takePillButton: UIButton!

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
}

extension HomeViewController {
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
