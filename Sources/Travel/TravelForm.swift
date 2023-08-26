//
//  TravelView.swift
//  BugDemo
//
//  Created by David Sinclair on 2023-02-20.
//  Copyright © 2023 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI
import MapKit

struct TravelForm: View {
    @EnvironmentObject var model: Model
    @EnvironmentObject var settings: Settings
    
    @Binding var isEditingTravel: Bool
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var showingLocation = false
    
    var row: Row
    
    var body: some View {
        VStack {
            Divider()
                .padding(.top, 1)
            
            Form {
                HStack {
                    WeatherDate(row: row)
                    
                    Spacer()
                    Button {
                        model.editingTravel = Travel.none
                        
                        withAnimation(.easeInOut) {
                            isEditingTravel = false
                        }
                    } label: {
                        Text("Cancel")
                    }
                    Button {
                        model.save(travel: model.editingTravel)
                        
                        model.editingTravel = Travel.none
                        
                        withAnimation(.easeInOut) {
                            isEditingTravel = false
                        }
                    } label: {
                        Text("Save")
                    }
                }
                .padding(.bottom)
                
                Picker("Events:", selection: $model.editingTravel.display) {
                    Text("Include location").tag(Travel.Display.include)
                    Text("Omit location").tag(Travel.Display.exclude)
                }
                
                Picker("Repeat:", selection: $model.editingTravel.scope) {
                    Text("Only use for this day").tag(Travel.Scope.onlyThisDay)
                    Text("Use this location for subsequent days").tag(Travel.Scope.useForSubsequentDays)
                }
                
                Picker("Values:", selection: $model.editingTravel.values) {
                    Text("Use the weather forecast").tag(Travel.Values.forecast)
                    Text("Use custom values").tag(Travel.Values.custom)
                }
            }
            .padding()
            
            Divider()
                .padding(.bottom, 1)
        }
//        .contentShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
//        .background(RoundedRectangle(cornerRadius: 6, style: .continuous)
//            .foregroundColor(.primary)
//            .padding([.top, .bottom], -3))
        
        .background(.gray.opacity(0.2))
        
//        .background(.thinMaterial)
        .padding(-5)
        
//        .background(
//            .regularMaterial,
//            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
//        )
    }
}

struct TravelForm_Previews: PreviewProvider {
    static var previews: some View {
        TravelForm(isEditingTravel: .constant(true), row: Row(day: Day.today, title: "Sample", detail: "Sample", location: "None", showMoreButton: false))
            .environmentObject(Model.shared)
    }
}
