//
//  StorageService.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

protocol StorageService {
    //    func saveHistory(_ data: Data) throws
    func readHistory() throws -> Data
    func deleteHistory() -> Bool
    func store(_ pill: Pill) -> Bool
}

enum HistoryError: Error {
    case generic
    case write
    case read
    case fileEmpty
}

final class Storage: StorageService {
    private let suitName = "group.com.alessioroberto.TakeURPill"

    func readHistory() throws -> Data {
        if let userDefaults = UserDefaults(suiteName: suitName),
            let history = userDefaults.userHistory {
            return history
        }
        
        throw HistoryError.fileEmpty
    }

    func deleteHistory() -> Bool {
        if let userDefaults = UserDefaults(suiteName: suitName) {
            userDefaults.userHistory = nil
            return true
        }
        return false
    }

    func store(_ pill: Pill) -> Bool {

        SiriService.donateInteraction(pill.intent) { error in
            if let error = error {
                logger(error)
            }
        }
        
        do {
            let json = try readHistory()

            if let list = Convert.convertToPills(json) {
                var newList = list
                newList.append(pill)
                if let newJson = Convert.convertToData(newList) {
                    try saveHistory(newJson)
                }
            }
        } catch let error as HistoryError {
            if error == .fileEmpty {
                if let newJson = Convert.convertToData([pill]) {
                    try? saveHistory(newJson)
                }
            } else {
                logger("\(error.localizedDescription)")
                return false
            }
        } catch {
            logger("Read Error")
            return false
        }
        return true
    }

    func getLastPill() -> Pill? {
        guard let data = try? readHistory() else {
            return nil
        }

        let history = Convert.convertToPills(data)
        return history?.sorted { $0.timestamp > $1.timestamp }.first
    }

    // MARK: - Private
    private func saveHistory(_ data: Data) throws {
        if let userDefaults = UserDefaults(suiteName: suitName) {
            userDefaults.userHistory = data
        } else {
            throw HistoryError.write
        }
    }
}

struct Convert {
    static func convertToPill(_ data: Data) -> Pill? {
        let decoder = JSONDecoder()
        return try? decoder.decode(Pill.self, from: data)
    }

    static func convertToPills(_ data: Data) -> [Pill]? {
        let decoder = JSONDecoder()
        return try? decoder.decode([Pill].self, from: data)
    }

    static func convertToData(_ pill: Pill) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(pill)
    }

    static func convertToData(_ list: [Pill]) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(list)
    }
}
