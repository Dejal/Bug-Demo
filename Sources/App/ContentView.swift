//
//  ContentView.swift
//  BugDemo
//
//  Created by David Sinclair on 2019-12-26.
//  Copyright © 2019-2022 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        NavigationStack {
            VStack {
#if os(macOS)
                HStack {
                    Spacer()
                    ActionMenu()
                }
                .padding([.top, .trailing], 15)
                .padding(.bottom, 5)
#endif
                
                DemoList()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
#if !os(macOS)
            .toolbar {
                ActionMenu()
            }
#endif
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Model.shared)
    }
}
