//
//  AppCache.swift
//

import Foundation
import SwiftDate

public class AppCache {
    public static let dailyRanking = "dailyRanking"
//    public static let dailyRecord = "dailyRecord"
    public static let dailyBreakCount = "dailyBreakCount"
    public static let point = "point"
    public static let monthRanking = "monthRanking"
    public static let apiDelay = "apiDelay"
    public static let messagesHome = "messagesHome"
    public static let messages = "messages"
    public static let breakGraph = "breakGraph"
    public static let isHealthKitDeliveried = "isHealthKitDeliveried"
    public static let isDebugMode = "isDebugMode"
    public static let isNeedShowMealList = "isNeedShowMealList"
    public static let courses = "courses"
    public static let stampAll = "stampAll"
    public static let isAuthorized = "isAuthorized"
    public static let fcmToken = "fcmToken"
    public static let isSignUp = "isSignUp"
    
    public static let defaultApiDelay = 1000
    
    private var cache = [String: Any]()
    
    private var expireTimes = [String: Date]()
    
    public static let ageLimit = 60
    
    private var neverExpiredKeys: Set<String> = []

    public static let ageLimitShort = 30 // graph api 30s

    public static let ageHealthKitDelivery = 5 * 60 // healthkit background delivery 5 mins

    public init() {
    }
    
    public func set(value: Any?, forKey: String, neverExpire: Bool = false, limit: Int = AppCache.ageLimit) {
        if neverExpire {
            neverExpiredKeys.insert(forKey)
        }
        
        setValue(value, for: forKey, limit: limit)
    }
    
    public func value(forKey: String) -> Any? {
        isExpired(key: forKey) ? nil : cache[forKey]
    }

    public func boolValue(forKey: String) -> Bool {
        (value(forKey: forKey) as? Bool) ?? false
    }

    private func setValue(_ value: Any?, for key: String, limit: Int = AppCache.ageLimit) {
        if let newValue = value {
            cache[key] = newValue
            expireTimes[key] = Date() + limit.seconds
        } else {
            cache[key] = nil
            expireTimes[key] = nil
        }
    }

    public func removeAllObjects() {
        cache.removeAll()
        expireTimes.removeAll()
    }

    public func remove(key: String) {
        set(value: nil, forKey: key)
    }

    private func isExpired(key: String) -> Bool {
        guard let expire = expireTimes[key] else {
            return false
        }
        
        guard neverExpiredKeys.contains(key) == false else {
            return false
        }
        
        return Date().isAfterDate(expire, granularity: .second)
    }
}
