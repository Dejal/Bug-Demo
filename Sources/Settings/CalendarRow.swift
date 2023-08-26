//
//  CalendarRow.swift
//  BugDemo
//
//  Created by David Sinclair on 2023-01-17.
//  Copyright © 2023 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

struct CalendarRow: View {
    var calendar: Cal
    
    var body: some View {
        HStack {
            image(for: calendar.color)
            
            Text("\(calendar.title)")
        }
        .tag(calendar)
    }
    
#if os(macOS)
    static var cachedColorImages = [Color : NSImage]()
#else
    static var cachedColorImages = [Color : UIImage]()
#endif
    
    func image(for color: Color) -> Image {
#if os(macOS)
        if let image = Self.cachedColorImages[color] {
            return Image(nsImage: image)
        }
        
        let image = NSImage(systemSymbolName: "square.fill", accessibilityDescription: nil)!
        
        image.isTemplate = false
        image.lockFocus()
        NSColor(color).set()
        let imageRect = NSRect(origin: .zero, size: image.size)
        imageRect.fill(using: .sourceIn)
        image.unlockFocus()
        
        Self.cachedColorImages[color] = image
        
        return Image(nsImage: image)
#else
//        if let image = Self.cachedColorImages[color] {
//            return Image(uiImage: image)
//        }
        
        let image = UIImage(systemName: "square.fill")!
            .withTintColor(UIColor(color))
        
        Self.cachedColorImages[color] = image
        
        return Image(uiImage: image)
#endif
    }
}

struct CalendarRow_Previews: PreviewProvider {
    static var previews: some View {
        CalendarRow(calendar: Cal(id: UUID().uuidString, title: "Example", color: Color.green))
    }
}
