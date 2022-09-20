import Foundation
import ObjectMapper
import SwiftDate

public struct DateTime {
    public static let region = Region(calendar: Calendars.iso8601, zone: Zones.asiaTokyo, locale: Locales.japaneseJapan)
    public static let parseFormats: [String] = [
        "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd HH:mm:ss Z",
        "yyyy-MM-dd",
        "yyyy-MM",
        "yyyyMMddHHmmss",
        "yyyyMM",
        "yyyyMMdd",
        "yyyy年M月",
        "yyyy",
        "yyyy年M月d日（E）"
    ]
    
    public static func setupRegion() {
        SwiftDate.defaultRegion = region
    }
    
    public static func parse(_ string: String?) -> Date? {
        guard string.isNotNilOrEmpty else {
            return nil
        }
        return string?.toDate(parseFormats, region: region)?.date
    }
    
    public static func parse(_ string: String?, format: String?) -> Date? {
        return string?.toDate(format, region: region)?.date
    }
}

public struct DateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    public let format: String
    
    public init(format: String) {
        self.format = format
    }
    
    public init() {
        self.init(format: "yyyy-MM-dd'T'HH:mm:ssXXX")
    }
        
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let string = value as? String {
            return DateTime.parse(string)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
//         DateToStringStyles.custom(format).toString(dt)
        return value?.toString(.custom(format))
    }
}

extension Date {
    public var fiscalYear: Int {
        month >= 4 ? year : year - 1
    }
    
    public var fiscalYearMin: Date {
        DateInRegion(year: fiscalYear, month: 4, day: 1).dateAtStartOf(.day).date
    }
    
    public var fiscalYearMax: Date {
        DateInRegion(year: fiscalYear + 1, month: 3, day: 31).dateAtEndOf(.day).date
    }
    
    public var isThisYear: Bool {
        year == Date().year
    }
    
    public var isThisMonth: Bool {
        compare(toDate: Date(), granularity: .month) == .orderedSame
    }
    
    public var isThisFisalYear: Bool {
        fiscalYear == Date().fiscalYear
    }
    
    public var isThreeMonthAgo: Bool {
        return (Date() - 3.months).isAfterDate(self, orEqual: true, granularity: .month)
    }
}

// MARK: - isInPast7DaysRange

extension Date {
    public var isInPast7DaysRange: Bool {
        var sevenDaysAgoDate = Date().dateAt(.startOfDay) - 7.days
        return self.isInRange(date: sevenDaysAgoDate, and: Date(), orEqual: true, granularity: .day)
    }
}

extension Optional where Wrapped == String {
    public var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
    
    public var isNotNilOrEmpty: Bool {
        !isNilOrEmpty
    }
}

extension DateRepresentable {
    public func toFormat(_ format: Format, locale: LocaleConvertible? = nil) -> String {
        return toFormat(format.rawValue, locale: locale)
    }
    
    public func toFormat(_ format: Format.Transform, locale: LocaleConvertible? = nil) -> String {
        return toFormat(format.rawValue, locale: locale)
    }
}

public enum Format: String {
    case short_JP_week = "yyyy年M月d日（E）"
    case short_JP_week_time = "yyyy年M月d日（E）HH:mm"
    case m_d_week_time = "M月d日（E）HH:mm"
    case HHmm = "HH:mm"
    case short_JP_noDay = "yyyy年M月"
    case short = "yyyy-M-d"
    case birthdayFull = "yyyyMMdd"
    case birthdayShort = "yyyyMM"
    case full = "yyyyMMddHHmmss"
    case birthdayDisplay = "yyyy年MM月dd日"
    case birthdayNoDayDisplay = "yyyy年MM月"
    case shortYear = "yyyy"
    case yyyyMMdd_slash = "yyyy/MM/dd"
    case yyyyJPYear = "yyyy年"
    case HHmmss = "HH:mm:ss"
    case yyyyMd = "yyyy年M月d日"
    case Md_HHmm_slash = "M/d HH:mm"
    case Md = "M月d日"
    case yyyyMd_JP_week_slash = "yyyy/M/d（E）"
    case yyyyMd_JP_week_slash_hannkaku = "yyyy/M/d(E)"
    case mde = "M月d日(E)"
    
    public enum Transform: String {
        case short = "yyyy-MM-dd"
        case long = "yyyy-MM-dd HH:mm:ss"
        case full = "yyyy-MM-dd'T'HH:mm:ssXXX"
        case yyyyMM = "yyyy-MM"
        case day = "dd"
    }
}
