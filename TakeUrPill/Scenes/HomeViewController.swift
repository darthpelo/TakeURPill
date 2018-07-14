//
//  HomeViewController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var takePillButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

        let pillName = Bool.random() ? "Red Pill" : "Blue Pill"

        let pill = Pill(timestamp: Date().timeIntervalSince1970,
                        ammount: 1,
                        name: pillName)

        do {
            let json = try storage.readHistory()
            var list = storage.convertToPills(json)

            if list != nil {
                list!.append(pill)
                if let newJson = storage.convertToData(list!) {
                    try storage.saveHistory(newJson)
                }
            }
        } catch let error as HistoryError {
            if error == .fileEmpty {
                if let newJson = storage.convertToData([pill]) {
                    try? storage.saveHistory(newJson)
                }
            } else {
                print("\(error.localizedDescription)")
            }
        } catch {
            print("Read Error")
        }
    }
}
