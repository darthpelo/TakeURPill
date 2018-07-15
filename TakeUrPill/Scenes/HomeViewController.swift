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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        activitySetup()
    }

    @IBAction func startButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowStartSession", sender: self)
    }

    @IBAction func takePillButtonPressed(_ sender: Any) {
        pillTook()
    }

    @IBAction func historyButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowHistory", sender: self)
    }
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
        //nothing goes here
    }

}

extension HomeViewController {
    private func pillTook() {
        let storage = Storage()

        let pillName = UserDefaults.standard.object(forKey: "pill.name") as? String
        let ammount = UserDefaults.standard.integer(forKey: "pill.ammount")

        let pill = Pill(timestamp: Date().timeIntervalSince1970,
                        ammount: ammount,
                        name: pillName)
        storage.store(pill)
    }

    private func activitySetup() {
        // give our activity a unique ID
        let activity = NSUserActivity(activityType: "com.mobiquityinc.demo.TakeUrPill.takepill")

        // give it a title that will be displayed to users
        activity.title = "I took my pill"

        // allow Siri to index this and use it for voice-matched queries
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        }

        // give the activity a unique identifier so we can delete it later if we need to
        if #available(iOS 12.0, *) {
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier("com.mobiquityinc.demo.TakeUrPill.takepill")
        }

        // You can also suggest the voice phrase that a user may want to use when adding a phrase to Siri
        activity.suggestedInvocationPhrase = "I took my pill"

        // make this activity active for the current view controller – this is what Siri will restore when the activity is triggered
        self.userActivity = activity

    }
}
