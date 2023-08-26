//
//  SettingsView.swift
//  BugDemo
//
//  Created by David Sinclair on 2022-11-11.
//  Copyright © 2022-2023 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: Model
    @EnvironmentObject var settings: Settings
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Form {
#if os(macOS)
            LaunchAtLogin.Toggle("Open Bug Demo at login")
                .padding(.bottom, 10)
            
            Text("Changes to these only affect events from today:")
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            calendar
            Spacer()
#else
            Section {
                calendar
            }
            
            Section {
                location
            }
            
            Section {
                options
            } footer: {
                Text("Changes to all of these settings only affect events from today.")
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
#endif
        }
#if os(macOS)
        .padding(20)
        .frame(width: 350, height: 400)
#endif
    }
    
    var calendar: some View {
        Group {
            if model.hasCalendarAccess {
                Picker("Calendar:", selection: $model.calendar) {
                    HStack {
                        Text("None")
                    }
                    .tag(Cal.none)
                    
                    Divider()
                    
                    ForEach(model.calendars.sorted(by: <)) { calendar in
                        CalendarRow(calendar: calendar)
                    }
                }
            } else {
                Button("Authorize Calendar Access") {
                    openURL(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars")!)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Model.shared)
    }
}
