//
//  Row.swift
//  BugDemo
//
//  Created by David Sinclair on 2022-11-07.
//  Copyright © 2022-2023 Dejal Systems, LLC. All rights reserved.
//

import Foundation

/// A row of info for the weather list.
struct Row {
    /// Day of the row.
    let day: Day
    
    /// The event title.
    let title: String
    
    /// The event description.
    let detail: String
    
    /// The event location.
    let location: String
    
    /// The date as s display string.
    var dateString: String {
        return day.dateString
    }
    
    /// Include a button to load more.
    let showMoreButton: Bool
}

extension Row: Identifiable {
    var id: Day {
        return day
    }
}

extension Row: Comparable, Equatable {
    static func < (lhs: Row, rhs: Row) -> Bool {
        return lhs.day < rhs.day
    }
}

extension Row: CustomStringConvertible {
    var description: String {
        return "Row date: \(dateString), title: \(title)"
    }
}
