//
//  AppDelegate.swift
//  BugDemo
//
//  Created by David Sinclair on 2023-01-16.
//  Copyright © 2023 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

#if os(macOS)
import AppKit

/// App delegate for the Mac app, to handle things not yet available via SwiftUI.
class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}

extension View {
    func withHostingWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

struct HostingWindowFinder: NSViewRepresentable {
    typealias NSViewType = NSView
    
    var callback: (NSWindow?) -> ()
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
    }
}
#endif
