//
//  Day.swift
//  BugDemo
//
//  Created by David Sinclair on 2023-01-30.
//  Copyright © 2023 Dejal Systems, LLC. All rights reserved.
//

import Foundation

/// Representation of a day.
struct Day: Identifiable, Hashable, Codable {
    let id: TimeInterval
    
    /// Initializer from an ID.
    init(id: TimeInterval) {
        self.id = id
    }
    
    /// Initializer for today. Should just use `.today` instead.
    init() {
        self.init(date: Date())
    }
    
    /// Initializer from a date.
    init(date: Date) {
        /// Sets `id` to noon on the given date.
        let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: date) ?? Calendar.current.startOfDay(for: date).addingTimeInterval(12 * 60 * 60)
        
        self.id = noon.timeIntervalSinceReferenceDate
    }
    
    /// Returns the date at noon.
    var noon: Date {
        return Date(timeIntervalSinceReferenceDate: id)
    }
    
    /// Returns the first instant of the day.
    var start: Date {
        return Calendar.current.startOfDay(for: noon)
    }
    
    /// Returns the last instant of the day.
    var end: Date {
        return interval?.end ?? noon.addingTimeInterval(12 * 60 * 60)
    }
    
    /// Returns the start-end interval of the day.
    var interval: DateInterval? {
        return Calendar.current.dateInterval(of: .day, for: noon)
    }
    
    /// The date as s display string.
    var dateString: String {
        let date = noon
        
        if Self.absoluteFormatter.string(from: date) == Self.relativeFormatter.string(from: date) {
            return Self.customFormatter.string(from: date)
        } else {
            return Self.relativeFormatter.string(from: date)
        }
    }
    
    static let absoluteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.locale = Locale.current
        formatter.timeZone = Locale.current.timeZone
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    static let relativeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.locale = Locale.current
        formatter.timeZone = Locale.current.timeZone
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
        
        return formatter
    }()
    
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.locale = Locale.current
        formatter.timeZone = Locale.current.timeZone
        formatter.setLocalizedDateFormatFromTemplate("EEEMMMd")
        
        return formatter
    }()
    
    /// Never as a `Day`.
    static let never = Day(date: .distantFuture)
    
    /// Today as a `Day`.
    static let today = Day()
}

extension Day: Comparable {
    static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.id < rhs.id
    }
}

extension Day: CustomStringConvertible {
    var description: String {
        return "Day \(dateString) (\(id))"
    }
}
