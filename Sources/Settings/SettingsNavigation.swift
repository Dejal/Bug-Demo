//
//  SettingsNavigation.swift
//  BugDemo
//
//  Created by David Sinclair on 2022-11-11.
//  Copyright © 2022 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

struct SettingsNavigation: View {
    @EnvironmentObject var model: Model
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            SettingsView()
                .navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Done") {
                            Task {
                                await save()
                            }
                        }
                        .disabled(isSaveDisabled)
                    }
                }
                .task {
                    Task.detached { @MainActor in
//                        await airportData.load()
                    }
                }
        }
    }
    
    func save() async {
//        await inputData.save(to: flightData, in: calendar)
        dismiss()
    }
    
    var isSaveDisabled: Bool {
        return false
//        inputData.destination == nil
    }
}

struct SettingsNavigation_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Model.shared)
    }
}
