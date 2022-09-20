//
//  ActivityRecord.swift
//

import SwiftDate

public struct ActivityRecord {
    public let orignalDate: Date
    public let steps: Int
    public var distance: Double
    public let day: String // yyyy-MM-dd
    public let weight: Double
    public let systolicBp: Double
    public let diastolicBp: Double

    public var date: Date? {
        DateTime.parse(day)
    }
    
    public var isToday: Bool {
        return date?.isToday ?? false
    }
    
    public static func averageStep(records: [ActivityRecord]) -> Int {
        if records.isEmpty {
            return 0
        }
        
        let isThisMonth = records.first?.date?.isThisMonth ?? false
        let totalDays = isThisMonth ? Date().day : records.count
        let totalSteps = records.map {
            $0.steps
        }
        .reduce(0, +)
        return totalSteps / totalDays
    }
}

extension ActivityRecord {
    public init(steps: Int, date: Date) {
        self.orignalDate = date
        self.steps = steps
        self.distance = 0
        self.day = date.toFormat("yyyy-MM-dd")
        self.weight = 0
        self.systolicBp = 0
        self.diastolicBp = 0
    }
    
    init(steps: Int, distance: Double, day: String, weight: Double) {
        self.steps = steps
        self.distance = distance
        self.weight = weight
        self.day = day
        self.systolicBp = 0
        self.diastolicBp = 0
        self.orignalDate = DateTime.parse(day) ?? Date()
    }
    
    init(orignalDate: Date, systolicBp: Double, diastolicBp: Double) {
        self.steps = 0
        self.distance = 0
        self.weight = 0
        self.orignalDate = orignalDate
        self.day = orignalDate.toFormat("yyyy-MM-dd")
        self.systolicBp = systolicBp
        self.diastolicBp = diastolicBp
    }
}

extension ActivityRecord: Equatable {
    public static func == (lhs: ActivityRecord, rhs: ActivityRecord) -> Bool {
        return lhs.steps == rhs.steps
    }
}

extension ActivityRecord: Comparable {
    public static func < (lhs: ActivityRecord, rhs: ActivityRecord) -> Bool {
        return lhs.steps < rhs.steps
    }
}
