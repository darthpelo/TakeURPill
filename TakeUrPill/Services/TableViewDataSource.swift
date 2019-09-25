//
//  TableViewDataSource.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 17/09/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import UIKit

protocol RowUpdateProtocol: class {
    func removeModel(at: Int)
}

final class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void

    weak var delegate: RowUpdateProtocol?

    fileprivate var models: [Model]

    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator

    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )

        cellConfigurator(model, cell)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delegate?.removeModel(at: indexPath.row)
        }
    }

    func cleanDataSource() {
        models.removeAll()
    }
}

extension TableViewDataSource where Model == Pill {
    static func make(for pills: [Pill],
                     reuseIdentifier: String = "HistoryCell") -> TableViewDataSource {
        return TableViewDataSource(
            models: pills,
            reuseIdentifier: reuseIdentifier
        ) { pill, cell in
            cell.textLabel?.text = pill.name
            cell.detailTextLabel?.text = DateFormatter.localizedString(from: Date(timeIntervalSince1970: pill.timestamp),
                                                                       dateStyle: .medium,
                                                                       timeStyle: .medium)
        }
    }
}

extension TableViewDataSource where Model == PillType {
    static func make(for pills: [PillType],
                     reuseIdentifier: String = "PillTypeCell") -> TableViewDataSource {
        return TableViewDataSource(
            models: pills,
            reuseIdentifier: reuseIdentifier
        ) { pill, cell in
            cell.textLabel?.text = pill.name
            cell.detailTextLabel?.text = "\(pill.amount)"
        }
    }
}
