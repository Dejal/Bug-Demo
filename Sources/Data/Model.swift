//
//  Model.swift
//  BugDemo
//
//  Created by David Sinclair on 2022-10-31.
//  Copyright © 2022-2023 Dejal Systems, LLC. All rights reserved.
//

import Foundation
import SwiftUI
import EventKit
import WeatherKit
import MapKit
import BackgroundTasks

/// A class to manage the app data, following the convention suggested by Apple's Fruta sample code.
@MainActor
class Model: ObservableObject {
    /// Singleton shared instance.
    static let shared = Model()
    
    static let settings = Settings()
    
    let settings = Model.settings
    
    @Published var editingTravel = Travel.none
    
    private var weatherService = WeatherService.shared
    
    var calendarStore = EKEventStore()
    var hasCalendarAccess = false
    
    @Published var calendars = [Cal]()
    
    @Published var calendar = Cal.none {
        didSet {
            settings.calendarIdentifier = calendar.id
            settings.calendarTitle = calendar.title
            
            updateInBackground()
        }
    }
    
    var manuallySettingLocation = false
    
    var travels = [Day : Travel]()
    
    var orderedTravels: [Travel] {
        return travels.values.sorted { $0.day < $1.day }
    }
    
    @Published var rows = [Row]()
    
    var earliestDate = Date()
    
    var endDate = Date()
    
    var timer: Timer?
    
    var hasCalendar: Bool {
        return hasCalendarAccess && calendar.id != "?"
    }
    
    var hasWeather: Bool {
        return false
    }
    
    var fetchedWeatherDate: Date?
    
    /// Private init to prevent others constructing a new instance.
    private init() {
        Task.detached { @MainActor in
            await self.prepare()
        }
    }
    
    func prepare() async {
        settings.prepare { kind in
            switch kind {
            case .setting:
                self.updateInBackground()
            case .travel:
                self.travels = self.settings.loadTravels()
                self.updateInBackground()
            }
        }
        
        travels = settings.loadTravels()
        
        do {
            hasCalendarAccess = try await calendarStore.requestFullAccessToEvents()
        } catch {
            print(error)
        }
        
        prepareCalendars()
        
        await update()
        
        prepareAttributionInfo()
        
#if os(macOS)
        let hour: TimeInterval = 60 * 60
        
        timer = Timer.scheduledTimer(withTimeInterval: hour, repeats: true) { timer in
            self.updateInBackground()
        }
#else
        scheduleAppRefresh()
#endif
    }
    
    func scheduleAppRefresh() {
#if !os(macOS)
        let request = BGAppRefreshTaskRequest(identifier: "com.dejal.BugDemo.refresh")
        let hour: TimeInterval = 60 * 60
        
        request.earliestBeginDate = .now.addingTimeInterval(hour)
        
        try? BGTaskScheduler.shared.submit(request)

#endif
    }
    
    nonisolated func updateInBackground() {
        Task.detached { @MainActor in
            await self.update()
        }
    }
    
    func update() async {
        scheduleAppRefresh()
        
        load(more: true)
    }
    
    var locationRegionWorkItem: DispatchWorkItem?
    
    func travel(onOrBefore day: Day) -> Travel {
        // Return a new Travel for the day, in case it is edited.
        if let travel = travels[day] {
            return Travel(day: day, travel: travel)
        }
        
        // Return a new Travel for the day, in case it is edited.
        if let travel = orderedTravels.last(where: { $0.day <= day && $0.scope == .useForSubsequentDays }) {
            return Travel(day: day, travel: travel)
        }
        
        // The above should always find a Travel, but just in case, use a copy of the first one, or an example one, to avoid having to return nil.
        if let travel = orderedTravels.first {
            return Travel(day: day, travel: travel)
        } else {
            return Travel(day: day)
        }
    }
    
    func save(travel: Travel) {
        travels[travel.day] = travel
        
        settings.save(travel: travel)
        
        updateInBackground()
    }
    
    func prepareCalendars() {
        calendars = calendarStore.calendars(for: .event).map { Cal(id: $0.calendarIdentifier, title: $0.title, color: Color(cgColor: $0.cgColor)) }
        
        if !calendars.isEmpty, let identifier = settings.calendarIdentifier, let title = settings.calendarTitle {
            let match = calendars.first { $0.id == identifier || $0.title == title }
            
            if let match {
                calendar = match
            } else {
                calendar = Cal.none
            }
        }
    }
    
    func load(more: Bool) {
        if more, let date = Calendar.current.date(byAdding: .day, value: -7, to: earliestDate) {
            earliestDate = date
        }
        
        let endDate = Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date()
        var date = earliestDate
        var wantMore = more
        
        rows.removeAll(keepingCapacity: true)
        
        while date < endDate {
            addRow(for: date, showMore: wantMore)
            date = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? endDate
            wantMore = false
        }
    }
    
    func addRow(for date: Date, showMore: Bool) {
        rows.removeAll { Calendar.current.isDate($0.day.noon, inSameDayAs: date) }
        
        rows.append(Row(day: Day(date: date), title: "Title", detail: "Detail", location: "Location", showMoreButton: showMore))
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.locale = Locale.current
        formatter.timeZone = Locale.current.timeZone
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    var statusString: String {
        return "🚧"
    }
    
    var statusTooltipString: String {
        return "This should be a tooltip on the menu bar extra"
    }
    
    var attributionInfo: WeatherAttribution?
    
    func prepareAttributionInfo() {
        Task.detached(priority: .background) {
            let attribution = try await self.weatherService.attribution
            
            DispatchQueue.main.async {
                self.attributionInfo = attribution
            }
        }
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
