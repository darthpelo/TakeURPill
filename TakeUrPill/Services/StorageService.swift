//
//  StorageService.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation
import Intents

protocol StorageService {
    //    func saveHistory(_ data: Data) throws
    func readHistory() throws -> Data
    func deleteFiles() -> Bool
    func store(_ pill: Pill) -> Bool
}

enum HistoryError: Error {
    case generic
    case write
    case read
    case fileEmpty
}

final class Storage: StorageService {
    private var json: String
    
    init(_ fileName: String = "sessions.json") {
        json = fileName
    }
    
    func readHistory() throws -> Data {
        if let userDefaults = UserDefaults.init(suiteName: "group.com.mobiquity.demo.TakeURPill"),
            let history = userDefaults.userHistory {
            return history
        }
        
        throw HistoryError.fileEmpty
    }
    
    func convertToPills(_ data: Data) -> [Pill]? {
        let decoder = JSONDecoder()
        return try? decoder.decode([Pill].self, from: data)
    }
    
    func convertToData(_ list: [Pill]) -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(list)
    }
    
    func deleteFiles() -> Bool {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
            return true
        } catch {
            return false
        }
    }
    
    func store(_ pill: Pill) -> Bool {
        if #available(iOS 12.0, *) {
            // Donate interaction to the system
            let interaction = INInteraction(intent: pill.intent, response: nil)
            logger(pill.intent)
            
            interaction.donate { (error) in
                if let error = error {
                    print(error)
                }
            }
        }
        
        do {
            let json = try readHistory()
            var list = convertToPills(json)
            
            if list != nil {
                list!.append(pill)
                if let newJson = convertToData(list!) {
                    try saveHistory(newJson)
                }
            }
        } catch let error as HistoryError {
            if error == .fileEmpty {
                if let newJson = convertToData([pill]) {
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
    
    private func saveHistory(_ data: Data) throws {
        if let userDefaults = UserDefaults.init(suiteName: "group.com.mobiquity.demo.TakeURPill") {
            userDefaults.userHistory = data
        } else {
            throw HistoryError.write
        }
    }
}
