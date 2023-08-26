//
//  AttributionView.swift
//  BugDemo
//
//  Created by David Sinclair on 2023-01-09.
//  Copyright © 2023 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

struct AttributionView: View {
    @EnvironmentObject var model: Model
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            if let attribution = model.attributionInfo {
                AsyncImage(url: colorScheme == .dark ? attribution.combinedMarkDarkURL : attribution.combinedMarkLightURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                } placeholder: {
//                    EmptyView()
//                    ProgressView()
                }
                let markdown = "[Other data sources](\(attribution.legalPageURL))"
                
                Text(.init(markdown))
            }
        }
#if os(macOS)
        .padding(.top, 20)
#endif
    }
}

struct AttributionView_Previews: PreviewProvider {
    static var previews: some View {
        AttributionView()
            .environmentObject(Model.shared)
    }
}
