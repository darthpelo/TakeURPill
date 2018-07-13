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

    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
        //nothing goes here
    }

}

