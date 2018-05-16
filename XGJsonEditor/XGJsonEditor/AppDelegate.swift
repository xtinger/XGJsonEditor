//
//  AppDelegate.swift
//  XGJsonEditor
//
//  Created by Denis Voronov on 16/05/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let filePath = Bundle.main.path(forResource: "topics", ofType: "json") {
            print("filePath OK")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let todo = try decoder.decode(RootModel.self, from: data)
                print("OK")
            }
            catch {
                print("ERROR")
            }
            
        }
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

