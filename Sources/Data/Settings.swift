//
//  Settings.swift
//  BugDemo
//
//  Created by David Sinclair on 2023-01-31.
//  Copyright © 2023 Dejal Systems, LLC. All rights reserved.
//

import Foundation
import SwiftUI

/// App settings, stored in user defaults and iCloud Key-Value Store.
class Settings: ObservableObject {
    private struct Key {
        static let calendarIdentifier = "calendarIdentifier"
        static let calendarTitle = "calendarTitle"
        static let travelPrefix = "travel-"
    }
    
    enum UpdateKind {
        case setting
        case travel
    }
    
    typealias SettingsUpdateCompletion = (UpdateKind) -> Void
    
    var settingsUpdateHandler: SettingsUpdateCompletion?
    
    var calendarIdentifier: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.calendarIdentifier)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.calendarIdentifier)
        }
    }
    
    var calendarTitle: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.calendarTitle)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.calendarTitle)
        }
    }
    
    let maximumNumberOfTravels = 20
    
    typealias DayTravelDictionary = [Day : Travel]
    
    func prepare(handler: @escaping SettingsUpdateCompletion) {
        settingsUpdateHandler = handler
        
        NotificationCenter.default.addObserver(forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default, queue: nil) { notification in
            guard let userInfo = notification.userInfo,
                  let reasonForChange = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int,
                  let keys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] else {
                return
            }

            if reasonForChange == NSUbiquitousKeyValueStoreAccountChange {
                // Probably ignore if the user changed iCloud accounts.
                return
            }
            
            print("Key-Value Store changed externally; reason: \(reasonForChange), changed keys: \(keys), user info: \(userInfo)")
            
            if keys.contains(where: { $0.hasPrefix(Key.travelPrefix) }) {
                self.settingsUpdateHandler?(.travel)
            }
            
            
            
            //TODO: 🚧 look at the userInfo dictionary to decide whether or not to include remote changes; see PrefsInCloud sample code and: https://developer.apple.com/library/archive/documentation/General/Conceptual/iCloudDesignGuide/Chapters/DesigningForKey-ValueDataIniCloud.html
        }
    }
    
    private func addDefaultTravels() -> DayTravelDictionary {
        var travels = DayTravelDictionary()
        let oneDay: TimeInterval = 24 * 60 * 60
        var interval = oneDay
        
        let day = Day(date: Date(timeIntervalSinceReferenceDate: interval))
        let travel = Travel(day: day)
        
        travels[day] = travel
        
        save(travel: travel)
        
        interval += oneDay
        
        return travels
    }
    
    private func prune(travels: inout DayTravelDictionary) {
        let orderedTravels = travels.values.sorted { $0.day < $1.day }
        
        print("should prune oldest travels: \(orderedTravels)")
        
        //TODO: 🚧 prune the oldest values, but don’t prune the latest non-one-off one; ensure at least one remains, if all are one-off
    }
    
    private func loadTravels(from dictionary: [String : Any]) -> DayTravelDictionary {
        let dictionary = dictionary.filter { $0.key.hasPrefix(Key.travelPrefix) }
        
        var travels = DayTravelDictionary()
        
        for (key, value) in dictionary {
            let key = key.dropFirst(Key.travelPrefix.count)
            
            guard let id = TimeInterval(key), let dict = value as? [String : Any] else {
                continue
            }
            
            let day = Day(id: id)
            let travel = Travel.from(dictionary: dict)
            
            travels[day] = travel
        }
        
        return travels
    }
    
    func loadTravels() -> DayTravelDictionary {
        NSUbiquitousKeyValueStore.default.synchronize()
        
        //TODO: 🚧 apple's sample code recommends always loading from user defaults; not sure if that'd be in sync, though?
        var travels = loadTravels(from: NSUbiquitousKeyValueStore.default.dictionaryRepresentation)
        
        if travels.isEmpty {
            travels = loadTravels(from: UserDefaults.standard.dictionaryRepresentation())
            
            for travel in travels.values {
                save(travel: travel)
            }
        }
        
        if travels.isEmpty {
            travels = addDefaultTravels()
        }
        
        if travels.count > maximumNumberOfTravels {
            prune(travels: &travels)
        }
        
        return travels
    }
    
    func save(travel: Travel) {
        let dictionary = travel.asDictionary
        let key = "\(Key.travelPrefix)\(travel.day.id)"
        
        UserDefaults.standard.set(dictionary, forKey: key)
        NSUbiquitousKeyValueStore.default.set(dictionary, forKey: key)
    }
}
