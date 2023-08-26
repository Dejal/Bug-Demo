//
//  Travel.swift
//  BugDemo
//
//  Created by David Sinclair on 2023-01-30.
//  Copyright © 2023 Dejal Systems, LLC. All rights reserved.
//

import Foundation

/// Class representing a day where the location changes.
class Travel: ObservableObject, Identifiable, Codable {
    /// Data version.
    let version = 1
    
    /// Identifier.
    let id: UUID
    
    /// The day of travel.
    let day: Day
    
    enum Scope: String, Codable {
        case onlyThisDay
        case useForSubsequentDays
    }
    
    /// Whether or not this location should be used for subsequent days. until changed again.
    @Published var scope: Scope
    
    enum Display: String, Codable {
        case exclude
        case include
    }
    
    /// Whether or not to include the location in the event.
    @Published var display: Display
    
    enum Values: String, Codable {
        case forecast
        case custom
    }
    
    /// Whether to use the forecast or custom values.
    @Published var values: Values
    
    /// If using custom values, the custom title.
    @Published var customTitle = ""
    
    /// If using custom values, the custom notes.
    @Published var customNotes = ""
    
    /// No travel, used to avoid an optional for editing travel.
    static let none = Travel(day: Day.never)
    
    /// Example for previews.
    static let example = Travel(day: Day.today)
    
    /// Initializer for a new travel day.
    init(day: Day, scope: Scope = .useForSubsequentDays, display: Display = .include, values: Values = .forecast) {
        self.id = UUID()
        self.day = day
        self.scope = scope
        self.display = display
        self.values = values
    }
    
    /// Initializer for a new travel day from an existing one.
    init(day: Day, travel: Travel) {
        self.id = UUID()
        self.day = day
        self.scope = travel.scope
        self.display = travel.display
        self.values = travel.values
    }
    
    enum CodingKeys: String, CodingKey {
        case version
        case id
        case day
        case location
        case scope
        case display
        case values
        case customTitle
        case customNotes
    }
    
    /// Initializer when loading.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        day = try container.decode(Day.self, forKey: .day)
        scope = try container.decode(Scope.self, forKey: .scope)
        display = try container.decode(Display.self, forKey: .display)
        values = try container.decode(Values.self, forKey: .values)
        customTitle = try container.decode(String.self, forKey: .customTitle)
        customNotes = try container.decode(String.self, forKey: .customNotes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(version, forKey: .version)
        try container.encode(id, forKey: .id)
        try container.encode(day, forKey: .day)
        try container.encode(scope, forKey: .scope)
        try container.encode(display, forKey: .display)
        try container.encode(values, forKey: .values)
        try container.encode(customTitle, forKey: .customTitle)
        try container.encode(customNotes, forKey: .customNotes)
    }
    
    /// Given a dictionary representation, returns a `Travel` instance, or `nil` if invalid.
    class func from(dictionary: [String : Any]) -> Self? {
        return try? DictionaryDecoder().decode(Self.self, from: dictionary)
    }
    
    /// Returns a dictionary representation of the receiver.
    var asDictionary: [String : Any]? {
        return try? DictionaryEncoder().encode(self)
    }
}

extension Travel: Comparable {
    static func < (lhs: Travel, rhs: Travel) -> Bool {
        return lhs.day < rhs.day
    }
    
    static func == (lhs: Travel, rhs: Travel) -> Bool {
        return lhs.day == rhs.day
    }
}

extension Travel: CustomStringConvertible {
    var description: String {
        return "Travel on \(day)\(scope == .useForSubsequentDays ? " and subsequent" : "")"
    }
}

// https://stackoverflow.com/questions/45209743/how-can-i-use-swift-s-codable-to-encode-into-a-dictionary

class DictionaryEncoder {
    private let encoder = JSONEncoder()
    
    func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try encoder.encode(value)
        
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
    }
}

class DictionaryDecoder {
    private let decoder = JSONDecoder()
    
    func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        return try decoder.decode(type, from: data)
    }
}
