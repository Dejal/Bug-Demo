//
//  BugDemoApp.swift
//  BugDemo
//
//  Created by David Sinclair on 2022-10-31.
//  Copyright © 2019-2023 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

@main
struct BugDemoApp: App {
    @StateObject var model = Model.shared
    @StateObject var settings = Model.settings
    
#if os(macOS)
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
#endif
    
    var body: some Scene {
#if os(macOS)
        MenuBarExtra(model.statusString) {
            ContentView()
                .environmentObject(model)
                .environmentObject(settings)
                .withHostingWindow { window in
                    window?.collectionBehavior = [.stationary, .canJoinAllSpaces, .fullScreenAuxiliary]
                }
        }
        .menuBarExtraStyle(.window)
//        .windowResizability(.contentSize)
//        .windowResizability(.contentMinSize)
//        .defaultSize(width: 1000, height: 1000)
        
        SwiftUI.Settings {
            SettingsView()
                .environmentObject(model)
                .environmentObject(settings)
        }
#else
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environmentObject(settings)
        }
        .backgroundTask(.appRefresh("com.dejal.BugDemo.refresh")) {
            await model.update()
        }
#endif
    }
}
