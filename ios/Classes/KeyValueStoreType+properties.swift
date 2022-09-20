//
//  KeyValueStoreType+properties.swift
//

import Foundation
import SwiftDate

extension KeyValueStoreType {
    // MARK: - Notification / Reminder
    
    public func setReminderDefaultTime() {
        guard isLocalNotificationEnabled else {
            return
        }
        
        // 初期状態
        if mealRecordRemindTime == nil {
            mealRecordRemindTime = Date().dateBySet(hour: 17, min: 0, secs: 0)
            weightRecordRemindTime = Date().dateBySet(hour: 19, min: 0, secs: 0)
            log.debug("Set weightRecordRemindTime: \(String(describing: self.weightRecordRemindTime?.description(with: Locale.current)))")
        }
    }
    
    public var isMealRecordedToday: Bool {
        get {
            guard let latestMealRecordDate = latestMealRecordDate else {
                return false
            }
            return latestMealRecordDate.isToday
        }
    }
    
    public var isWeightRecordedToday: Bool {
        get {
            guard let latestWeightRecordDate = latestWeightRecordDate else {
                return false
            }
            return latestWeightRecordDate.isToday
        }
    }
    
//    public func getReminderStartDateFor(type: LocalNotificationType) -> Date? {
//        switch type {
//        case .mealInputReminder:
//            guard let storedDate = mealRecordRemindTime,
//                  let todayTriggerDate = Date().dateBySet(hour: storedDate.hour, min: storedDate.minute, secs: storedDate.second) else {
//                return nil
//            }
//            if self.isMealRecordedToday || Date() > todayTriggerDate {
//                // return tomorrow
//                // Current year, month, day + stored hour, minute, second
//                return storedDate.dateBySet([.year: Date().year, .month: Date().month, .day: Date().day + 1])
//            } else {
//                // return today
//                return  storedDate.dateBySet([.year: Date().year, .month: Date().month, .day: Date().day])
//            }
//
//        case .weightInputReminder:
//            guard let storedDate = weightRecordRemindTime,
//                  let todayTriggerDate = Date().dateBySet(hour: storedDate.hour, min: storedDate.minute, secs: storedDate.second) else {
//                return nil
//            }
//
//            if self.isWeightRecordedToday || Date() > todayTriggerDate {
//                // return tomorrow
//                return storedDate.dateBySet([.year: Date().year, .month: Date().month, .day: Date().day + 1])
//            } else {
//                // return today
//                return  storedDate.dateBySet([.year: Date().year, .month: Date().month, .day: Date().day])
//            }
//
//        case .examinationResult:
//            return examinationRecordRemindTime
//
//        default:
//            return nil
//        }
//    }
    
    // MARK: - HealthKit HealthKitFilterType
    public var filterType: HealthKitFilterType {
        if isFitbitEnabled {
            return .fitbit
        } else if isAppleWatchOnly {
            return .appleWatch
        }
        
        return .maxValue
    }
    
    // MARK: - Calculate Increase Point
    public func getIncreasePoint(totalPoint: Int) -> Int {
        if totalPoint <= 0 {
            log.debug("totalPoint <= 0, return 0")
            return 0
        }
        
        if lastPoints == Constants.lastPointsDefaultValue {
            // HomeViewModel two get point trigger: viewWillAppear; uploadHistoryActivitySuccess
            // FIRST LAUNCH viewWillAppear: set lastPoints = 0
            lastPoints = 0
            log.debug("lastPoints = \(Constants.lastPointsDefaultValue), set to 0")
            return 0
            // (FIRST LAUNCH uploadHistoryActivitySuccess: Calculate increased value↓)
        }
        
        if totalPoint <= lastPoints {
            log.debug("totalPoint:\(totalPoint); lastPoints:\(lastPoints), return 0")
            return 0
        }
        
        let increasePoint = totalPoint - lastPoints
        log.debug("Get Increase Point:\(increasePoint); total:\(totalPoint), lastPoints:\(lastPoints)")
        
        lastPoints = totalPoint
        return increasePoint
    }
    
    // MARK: -
}
