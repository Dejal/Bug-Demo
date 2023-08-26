//
//  Cal.swift
//  BugDemo
//
//  Created by David Sinclair on 2022-11-11.
//  Copyright © 2022-2023 Dejal Systems, LLC. All rights reserved.
//

import SwiftUI

/// Representing a calendar. (Not calling it `Calendar` to avoid conflicting with the Foundation one.)
struct Cal {
    /// Identifier of the calendar.
    let id: String
    
    /// Name of the calendar.
    let title: String
    
    /// Color of the calendar.
    let color: Color
    
    static let none = Cal(id: "none", title: "None", color: Color.clear)
}

extension Cal: Identifiable, Hashable {
}

extension Cal: Comparable {
    static func < (lhs: Cal, rhs: Cal) -> Bool {
        return lhs.title < rhs.title
    }
}
