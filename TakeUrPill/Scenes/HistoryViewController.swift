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

    override func viewWillAppear(_ animated: Bool) {
        list = getHistory().sorted {$0.timestamp > $1.timestamp }
    }

    @IBAction func eraseHistoryButtonPressed(_ sender: Any) {
        let storage = Storage()
        if storage.deleteFiles() == false {
            print("Error erasing file")
        } else {
            list = getHistory().sorted {$0.timestamp > $1.timestamp }
            tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
