//
//  StorageService.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

protocol StorageService {
    func saveHistory(_ data: Data) throws
    func readHistory() throws -> Data
    func deleteFiles() -> Bool
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

    func saveHistory(_ data: Data) throws {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(json)

            //writing
            do {
                try data.write(to: fileURL, options: .atomic)
            } catch {
                throw HistoryError.write
            }
        }
    }

    func readHistory() throws -> Data {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(json)

            //reading
            do {
                return try Data(contentsOf: fileURL)
            } catch {
                throw HistoryError.fileEmpty
            }
        }

        throw HistoryError.generic
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
}
