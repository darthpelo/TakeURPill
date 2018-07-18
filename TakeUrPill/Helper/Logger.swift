//
//  Logger.swift
//  TakeUrPill
//
//  Created by Alessio Roberto on 17/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import Foundation

func logger<T>(_ object: T, filename: String = #file, line: Int = #line, funcname: String = #function) {
    #if DEBUG
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss:SSS"
    let process = ProcessInfo.processInfo

    print("\(dateFormatter.string(from: NSDate() as Date)) \(process.processName))[\(process.processIdentifier)]\n \(filename)(\(line))\n \(funcname):\r\t\(object)\n")
    #endif
}
