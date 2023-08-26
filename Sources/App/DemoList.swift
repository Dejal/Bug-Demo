//
//  DemoList.swift
//  BugDemo
//
//  Created by David Sinclair on 2022-11-07.
//  Copyright © 2022-2023 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

struct DemoList: View {
    @EnvironmentObject var model: Model
//    @State private var deferredScroll = false
    @State private var editingTravel: Travel?
    
    var body: some View {
//        ScrollViewReader { proxy in
        if model.rows.isEmpty {
            Spacer()
            ProgressView {
                Text("Loading…")
            }
            .frame(width: 350, height: 650)
            
            Spacer()
//        } else if true {
//            ScrollView {
//                ForEach(0..<50) { i in
//                    Text("Item \(i)")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(.blue)
//                        .clipShape(.rect(cornerRadius: 25))
//                }
//            }
//            .frame(width: 350, height: 650)
//            .defaultScrollAnchor(.bottom)
            } else {
//                ScrollView {
                    List(model.rows) { row in
                        //                    ExperimentalView()
                        DemoRow(row: row)
                    }
                    .padding([.leading, .trailing], -10)
                    // works, but I think I'll stick with the button.
                    //                .refreshable {
                    //                    model.load(more: true)
                    //                }
#if os(macOS)
                    .frame(width: 350, height: 650)
#endif
                    
//                    //                .onChange(of: deferredScroll, perform: { value in
//                    //                    if model.rows.count > 0 {
//                    //                        proxy.scrollTo(model.rows[model.rows.count / 2].id, anchor: .top)
//                    //                    }
//                    //                })
//                    //                .onAppear {
//                    //                    Task.detached { @MainActor in
//                    //                        deferredScroll = true
//                    //                    }
//                    //                }
//                }
                .defaultScrollAnchor(.bottom)
            }
//        }
    }
}

struct DemoList_Previews: PreviewProvider {
    static var previews: some View {
        DemoList()
            .environmentObject(Model.shared)
    }
}
