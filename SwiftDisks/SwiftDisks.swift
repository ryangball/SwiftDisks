//
//  SwiftDisks.swift
//  SwiftDisks
//
//  Created by Keaton Burleson on 6/24/20.
//  Copyright © 2020 Keaton Burleson. All rights reserved.
//

import Foundation

public class SwiftDisks {

    
    public static func getAllDisks(_ callback: @escaping ([DisksAndPartitions]) -> ()) {
        let scriptPath = "\(Bundle(identifier: "kbrleson.SwiftDisks")!.resourcePath!)/list-disks-json.sh"
        var allDisks: [DisksAndPartitions] = []
        
        
        self.createTask(command: "/bin/bash", arguments: [scriptPath]) { (jsonData, error) in
            do {
                let listDisks = try JSONDecoder().decode(DiskList.self, from: jsonData)
                allDisks = listDisks.allDisksAndPartitions
                callback(allDisks)
            } catch {
                print("Error parsing Disk Utility output: \(error.localizedDescription)")
                callback(allDisks)
            }
        }
        
    }



    private static func createTask(command: String, arguments: [String], callback: @escaping (Data, String?) -> ()) {
        let task = Process()
        let errorPipe = Pipe()
        let standardPipe = Pipe()

        task.standardError = errorPipe
        task.standardOutput = standardPipe

        task.launchPath = command
        task.arguments = arguments

        task.terminationHandler = { (process) in
            if(process.isRunning == false) {
                let standardHandle = standardPipe.fileHandleForReading
                let standardData = standardHandle.readDataToEndOfFile()

                let errorHandle = errorPipe.fileHandleForReading
                let errorData = errorHandle.readDataToEndOfFile()
                let taskErrorOutput = String (data: errorData, encoding: String.Encoding.utf8)

                callback(standardData, taskErrorOutput)
            }
        }

        task.launch()
    }
}
