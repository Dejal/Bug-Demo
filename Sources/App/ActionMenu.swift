//
//  ActionMenu.swift
//  BugDemo
//
//  Created by David Sinclair on 2022-11-11.
//  Copyright © 2022-2023 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

struct ActionMenu: View {
    @EnvironmentObject var model: Model
    
    @Environment(\.openWindow) private var openWindow
    
    @State private var showingAbout = false
//    @State private var showingUpdates = false
    @State private var showingSettings = false
    
    var body: some View {
        Menu {
            Button {
#if os(macOS)
                NSApp.activate(ignoringOtherApps: true)
                openWindow(id: "about")
#else
                showingAbout.toggle()
#endif
            } label: {
                Text("About")
            }
            
//            Button {
//#if os(macOS)
//                NSApp.activate(ignoringOtherApps: true)
//#endif
//                showingUpdates.toggle()
//            } label: {
//                Text("Updates")
//            }
            
            Divider()
            
            SettingsLink()
            
//            Button {
//#if os(macOS)
//                NSApp.activate(ignoringOtherApps: true)
//                NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
//#else
//                showingSettings.toggle()
//#endif
//            } label: {
//                Text("Settings…")
//            }
            
#if os(macOS)
            Divider()
            
            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Text("Quit")
            }
#endif
        } label: {
            Image(systemName: "ellipsis.circle")
        }
        .menuStyle(.button)
        .buttonStyle(.borderless)
        .sheet(isPresented: $showingSettings) {
            SettingsNavigation()
        }
//        .sheet(isPresented: $showingUpdates) {
//            UpdatesView()
//        }
    }
}

struct ActionMenu_Previews: PreviewProvider {
    static var previews: some View {
        ActionMenu()
    }
}
