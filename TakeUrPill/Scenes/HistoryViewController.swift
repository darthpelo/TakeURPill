//
//  HistoryViewController.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 14/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var list: [Pill] = []
    private lazy var notification = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        notification.addObserver(self,
                                 selector: #selector(reload),
                                 name: UIApplication.willEnterForegroundNotification,
                                 object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        list = getHistory().sorted {$0.timestamp > $1.timestamp }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        activitySetup(ActivityInformation(activityType: "com.mobiquityinc.demo.TakeUrPill.history",
                                          activityTitle: "List of all pills I took"))
    }

    deinit {
        notification.removeObserver(self)
    }

    @IBAction func eraseHistoryButtonPressed(_ sender: Any) {
        let storage = Storage()
        if storage.deleteHistory() == false {
            print("Error erasing file")
        } else {
            list = getHistory().sorted {$0.timestamp > $1.timestamp }
            tableView.reloadData()
        }
    }

    @objc func reload() {
        list = getHistory().sorted {$0.timestamp > $1.timestamp }
        tableView.reloadData()
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

extension HistoryViewController {
    private func getHistory() -> [Pill] {
        let storage = Storage()

        var list: [Pill] = []

        do {
            let data = try storage.readHistory()
            let decoder = JSONDecoder()
            list = try decoder.decode([Pill].self, from: data)
        } catch {}

        return list
    }
}
