//
//  HealthKit+Rx.swift
//

import HealthKit
import RxSwift
import SwiftDate
import DeviceKit
import RxSwiftExt
import RxOptional

public enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
}

extension HKHealthStore {
    public static var isAuthorized: Observable<Bool> {
        return Observable.create { observer in
            #if MALLWALKING
            let healthKitTypesToWrite = Set([
                HKQuantityType.bodyMass,
                HKQuantityType.bodyFatPercentage,
                HKQuantityType.bloodPressureSystolic,
                HKQuantityType.bloodPressureDiastolic
            ])
            let healthKitTypesToRead = Set([
                HKQuantityType.bodyMass,
                HKQuantityType.bodyFatPercentage,
                HKQuantityType.bloodPressureSystolic,
                HKQuantityType.bloodPressureDiastolic,
                HKQuantityType.stepCount,
                HKQuantityType.distanceWalkingRunning,
                HKQuantityType.flightsClimbed
            ])
            #else
            let stepCountObjectType = HKObjectType.quantityType(forIdentifier: .stepCount)!
            let distanceWalkingRunningObjectType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
            
            let healthKitTypesToWrite: Set<HKSampleType> = []
            let healthKitTypesToRead: Set<HKObjectType> = [
                stepCountObjectType,
                distanceWalkingRunningObjectType
            ]
            #endif
            
            if !HKHealthStore.isHealthDataAvailable() {
                observer.onError(HealthkitSetupError.notAvailableOnDevice)
            } else {
                observer.onNext(false)
                KLHKStore.requestAuthorization(
                    toShare: healthKitTypesToWrite,
                    read: healthKitTypesToRead
                ) { success, error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(success)
                        observer.onCompleted()
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    public static var requestWeightAuthorizationAndCheckIfRequested: Observable<Bool> {
        return Observable.create { observer in
            let weightObjectType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
            
            let healthKitTypesToWrite: Set<HKSampleType> = []
            let healthKitTypesToRead: Set<HKObjectType> = [weightObjectType]
            
            if !HKHealthStore.isHealthDataAvailable() {
                observer.onError(HealthkitSetupError.notAvailableOnDevice)
            } else {
                observer.onNext(false)
                KLHKStore.requestAuthorization(
                    toShare: healthKitTypesToWrite,
                    read: healthKitTypesToRead
                ) { success, error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(success)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    public static var requestBpAuthorizationAndCheckIfRequested: Observable<Bool> {
        return Observable.create { observer in
            let systolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!
            let diastolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!
            
            let healthKitTypesToWrite: Set<HKSampleType> = []
            let healthKitTypesToRead: Set<HKObjectType> = [systolicType, diastolicType]
            
            if !HKHealthStore.isHealthDataAvailable() {
                observer.onError(HealthkitSetupError.notAvailableOnDevice)
            } else {
                observer.onNext(false)
                KLHKStore.requestAuthorization(
                    toShare: healthKitTypesToWrite,
                    read: healthKitTypesToRead
                ) { success, error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(success)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
}

// MARK: - HealthKit

public enum HealthKit {
    public static var isDebug = false
    typealias RawDatas = [String: Double]// Double: Steps or Distance
}

public enum HealthKitFilterType {
    case maxValue, appleWatch, iPhone, fitbit
}

extension HealthKit {
    public static func getWeight() -> Observable<[ActivityRecord]> {
        getDailyWeight(startDay: (Date() - 3.months).dateAt(.startOfDay), endDay: Date().dateAt(.endOfDay))
    }
    
    public static func getBp() -> Observable<[ActivityRecord]> {
        getDailyBp(startDay: (Date() - 3.months).dateAt(.startOfDay), endDay: Date().dateAt(.endOfDay))
    }
    
    public static func getHistoryActivities(filterType: HealthKitFilterType) -> Observable<[ActivityRecord]> {
        return getDailyActivity(startDay: (Date() - Constants.maxHomeDay.days).dateAt(.startOfDay),
                                endDay: Date().dateAt(.endOfDay),
                                filterType: filterType)
    }

    public static func getLastWeekActivities(filterType: HealthKitFilterType) -> Observable<[ActivityRecord]> {
        return getDailyActivity(startDay: (Date() - 6.days).dateAt(.startOfDay), endDay: Date().dateAt(.endOfDay), filterType: filterType)
    }
    
    public static func getGunmaLastWeekActivities(filterType: HealthKitFilterType) -> Observable<[ActivityRecord]> {
        return getDailyActivity(startDay: ((Date() - 1.days) - 6.days).dateAt(.startOfDay),
                                endDay: (Date() - 1.days).dateAt(.endOfDay),
                                filterType: filterType)
    }

    public static func getTodayActivity(filterType: HealthKitFilterType) -> Observable<ActivityRecord> {
        return getOneDayActivityAt(date: Date(), filterType: filterType).map {
            $0 ?? ActivityRecord(steps: 0, date: Date())
        }
    }
    
    public static func getLast2DaysActivity(filterType: HealthKitFilterType) -> Observable<[ActivityRecord]> {
        return getDailyActivity(startDay: Date().dateAt(.yesterdayAtStart), endDay: Date().dateAt(.endOfDay), filterType: filterType)
    }
    
    public static func getOneDayActivityAt(date: Date,
                                           filterUserInput: Bool = HealthKit.isDebug,
                                           dateFormat: Format.Transform = .short,
                                           filterType: HealthKitFilterType) -> Observable<ActivityRecord?> {
        return getDailyActivity(startDay: date.dateAt(.startOfDay),
                                endDay: date.dateAt(.endOfDay),
                                filterUserInput: filterUserInput,
                                dateFormat: dateFormat,
                                filterType: filterType).mapAt(\.last)
    }
    
    // only for karadalive
    public static func getMonthlyActivityWith(date: Date,
                                              filterUserInput: Bool = HealthKit.isDebug,
                                              dateFormat: Format.Transform = .short) -> Observable<[ActivityRecord]> {
        log.debug("current date: \(date), startOfMonth: \(date.dateAt(.startOfMonth)), endOfMonth: \(date.dateAt(.endOfMonth))")
        
        return getDailyActivity(startDay: date.dateAt(.startOfMonth),
                                endDay: date.dateAt(.endOfMonth),
                                filterUserInput: filterUserInput,
                                dateFormat: dateFormat)
    }
    
    public static func isHealthKitDenied() -> Observable<Bool> {
        return hasTwoMonthStepData().not()
    }
    
    public static func isWeightAuthorizationDenied() -> Observable<Bool> {
        return getDailyWeight(startDay: (Date() - 12.months).dateAt(.startOfDay), endDay: Date().dateAt(.endOfDay))
            .map { $0.isEmpty }
    }
    
    public static func isBpAuthorizationDenied() -> Observable<Bool> {
        return getDailyBp(startDay: (Date() - 12.months).dateAt(.startOfDay), endDay: Date().dateAt(.endOfDay))
            .map { $0.isEmpty }
    }
    
    public static func getDailyActivity(startDay: Date,
                                        endDay: Date,
                                        filterUserInput: Bool = HealthKit.isDebug,
                                        dateFormat: Format.Transform = .short,
                                        filterType: HealthKitFilterType = .maxValue) -> Observable<[ActivityRecord]> {
        let rawStep = getPredicates(start: startDay, to: endDay, filterUserInput: filterUserInput)
            .flatMapLatest {
                getDailyDataFrom(startDay,
                                 to: endDay,
                                 identifier: .stepCount,
                                 unit: .count(),
                                 predicate: $0,
                                 dateFormat: dateFormat,
                                 filterType: filterType)
                .catchErrorJustComplete()
            }
        
        let rawDistance = getPredicates(start: startDay, to: endDay, filterUserInput: filterUserInput)
            .flatMapLatest {
                getDailyDataFrom(startDay,
                                 to: endDay,
                                 identifier: .distanceWalkingRunning,
                                 unit: .meter(),
                                 predicate: $0,
                                 dateFormat: dateFormat,
                                 filterType: filterType)
                .catchErrorJustComplete()
            }
        
        return Observable.zip(rawStep, rawDistance) { steps, distance -> [ActivityRecord] in
            var activityRecords = [ActivityRecord]()
            steps.forEach { dateStr, step in
                let distance = distance[dateStr] ?? 0
                let activityRecord = ActivityRecord(steps: Int(step), distance: floor(distance), day: dateStr, weight: 0)
                activityRecords.append(activityRecord)
            }
            
            let sorted = activityRecords.sorted {
                $0.day < $1.day
            }
            
            return sorted
        }
    }
    
    private static func getDailyWeight(startDay: Date,
                                       endDay: Date,
                                       filterUserInput: Bool = HealthKit.isDebug,
                                       dateFormat: Format.Transform = .short) -> Observable<[ActivityRecord]> {
        var options: HKStatisticsOptions = []
        
        if #available(iOS 13.0, *) {
            options = [.mostRecent]
        } else if #available(iOS 12.0, *) {
            options = [.discreteMostRecent]
        } else {
            // Fallback on earlier versions
        }
        
        let rawWeight = getPredicates(start: startDay, to: endDay, filterUserInput: filterUserInput)
            .flatMapLatest {
                getWeightFrom(startDay,
                                 to: endDay,
                                 identifier: .bodyMass,
                                 unit: .gramUnit(with: .kilo),
                                 options: options,
                                 predicate: $0,
                                 dateFormat: dateFormat)
            }
            .map { weights -> [ActivityRecord] in
                var activityRecords = [ActivityRecord]()
                weights.forEach { dateStr, weight in
                    let activityRecord = ActivityRecord(steps: 0, distance: 0, day: dateStr, weight: weight)
                    activityRecords.append(activityRecord)
                }
                
                let sorted = activityRecords.sorted {
                    $0.day < $1.day
                }
                
                return sorted
            }
        
        return rawWeight
    }

    private static func getDailyBp(startDay: Date,
                                   endDay: Date,
                                   filterUserInput: Bool = HealthKit.isDebug,
                                   dateFormat: Format.Transform = .short) -> Observable<[ActivityRecord]> {
        var options: HKStatisticsOptions = []
        
        if #available(iOS 13.0, *) {
            options = [.mostRecent]
        } else if #available(iOS 12.0, *) {
            options = [.discreteMostRecent]
        } else {
            // Fallback on earlier versions
        }
        
        let rawData = getPredicates(
            start: startDay,
            to: endDay,
            filterUserInput: filterUserInput).flatMapLatest {
                getBpFrom(
                    startDay,
                    to: endDay,
                    identifier: .bodyMass, // unused
                    unit: .millimeterOfMercury(),
                    options: options,
                    predicate: $0,
                    dateFormat: dateFormat)
        }
        
        return rawData
    }
    
    private static func getPredicates(start startDate: Date,
                                      to endDate: Date,
                                      filterUserInput: Bool = HealthKit.isDebug) -> Observable<NSCompoundPredicate> {
        return Observable.create { observer in
            let timePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [.strictStartDate, .strictEndDate])
            let filterUserInputPredicate = NSPredicate(format: "metadata.%K != YES", HKMetadataKeyWasUserEntered)
            var predicates = [timePredicate]
            
            predicates = filterUserInput ? predicates : predicates + [filterUserInputPredicate]
            observer.onNext(NSCompoundPredicate(type: .and, subpredicates: predicates))
            
            return Disposables.create()
        }
    }
    
    private static func getDailyDataFrom(_ start: Date,
                                         to: Date,
                                         identifier: HKQuantityTypeIdentifier,
                                         unit: HKUnit,
                                         options: HKStatisticsOptions = [.separateBySource, .cumulativeSum],
                                         predicate: NSCompoundPredicate,
                                         dateFormat: Format.Transform = .short,
                                         filterType: HealthKitFilterType) -> Observable<RawDatas> {
        return Observable.create { observer in
            var interval = DateComponents()
            interval.day = 1
            let anchorDate = Date().dateAt(.startOfDay)
            
            let stepsQuery = HKStatisticsCollectionQuery(quantityType: HKQuantityType.quantityType(forIdentifier: identifier)!,
                                                         quantitySamplePredicate: predicate,
                                                         options: options,
                                                         anchorDate: anchorDate,
                                                         intervalComponents: interval)
            
            stepsQuery.initialResultsHandler = { _, results, error in
                DispatchQueue.main.async {
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    
                    guard let results = results else {
                        observer.onNext(RawDatas())
                        return
                    }
                    
                    let rawDatas = results.statistics()
                        .map { getValueFrom($0, unit: unit, filterType: filterType) }
                        .reduce([:]) {
                            $0.merging([$1.date: $1.value], uniquingKeysWith: +)
                        }
                    
                    observer.onNext(rawDatas)
                }
            }
            
            KLHKStore.execute(stepsQuery)
            
            return Disposables.create()
        }
    }
    
    private static func getWeightFrom(_ start: Date,
                                         to: Date,
                                         identifier: HKQuantityTypeIdentifier,
                                         unit: HKUnit,
                                         options: HKStatisticsOptions = [],
                                         predicate: NSCompoundPredicate,
                                         dateFormat: Format.Transform = .short) -> Observable<RawDatas> {
        return Observable.create { observer in
            var interval = DateComponents()
            interval.day = 1
            let anchorDate = Date().dateAt(.startOfDay)
            
            let stepsQuery = HKStatisticsCollectionQuery(quantityType: HKQuantityType.quantityType(forIdentifier: identifier)!,
                                                         quantitySamplePredicate: predicate,
                                                         options: options,
                                                         anchorDate: anchorDate,
                                                         intervalComponents: interval)
            
            stepsQuery.initialResultsHandler = { _, results, error in
                DispatchQueue.main.async {
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    
                    guard let results = results else {
                        observer.onNext(RawDatas())
                        return
                    }
                    
                    let rawDatas = results.statistics()
                        .map { getMaxValueFrom($0, unit: unit) }
                        .reduce([:]) {
                            $0.merging([$1.date: $1.value], uniquingKeysWith: +)
                        }
                    
                    observer.onNext(rawDatas)
                }
            }
            
            KLHKStore.execute(stepsQuery)
            
            return Disposables.create()
        }
    }
    
    private static func getBpFrom(_ start: Date,
                                  to: Date,
                                  identifier: HKQuantityTypeIdentifier,
                                  unit: HKUnit,
                                  options: HKStatisticsOptions = [],
                                  predicate: NSCompoundPredicate,
                                  dateFormat: Format.Transform = .short) -> Observable<[ActivityRecord]> {
        return Observable.create { observer in
            let systolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!
            let diastolicType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!
            
            let targetType = HKQuantityType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure)!
            
            let query = HKCorrelationQuery(type: targetType,
                                           predicate: predicate,
                                           samplePredicates: nil) { _, correlations, error in
                DispatchQueue.main.async {
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    
                    guard let correlations = correlations else {
                        observer.onNext([])
                        return
                    }
                    
                    let records = correlations.map { correlation -> ActivityRecord in
                        let systolicSample = correlation.objects(for: systolicType).first as! HKQuantitySample
                        let systolicQuantity = systolicSample.quantity
                        
                        let diastolicSample = correlation.objects(for: diastolicType).first as! HKQuantitySample
                        let diastolicQuantity = diastolicSample.quantity
                        
                        let date = systolicSample.startDate
                        
                        let record = ActivityRecord(orignalDate: date,
                                                    systolicBp: systolicQuantity.doubleValue(for: unit),
                                                    diastolicBp: diastolicQuantity.doubleValue(for: unit))
                        return record
                    }
                    
                    let dic = Dictionary(grouping: records) {
                        $0.day
                    }
                    
                    let result = dic.compactMap {
                        $0.value.max {
                            $0.orignalDate < $1.orignalDate
                        }
                    }
                    
                    observer.onNext(result)
                }
            }
            
            KLHKStore.execute(query)
            
            return Disposables.create()
        }
    }
    
    // sample version
//    private static func getWeightFrom(_ start: Date,
//                                      to: Date,
//                                      identifier: HKQuantityTypeIdentifier,
//                                      unit: HKUnit,
//                                      options: HKStatisticsOptions = [.separateBySource, .cumulativeSum],
//                                      predicate: NSCompoundPredicate,
//                                      dateFormat: Format.Transform = .short) -> Observable<[Double]> {
//        return Observable.create { observer in
//            let query = HKSampleQuery(
//                sampleType: HKSampleType.quantityType(forIdentifier: identifier)!,
//                predicate: predicate,
//                limit: HKObjectQueryNoLimit,
//                sortDescriptors: nil) { query, samples, error in
//                    DispatchQueue.main.async {
//                        if let error = error {
//                            observer.onError(error)
//                            return
//                        }
//
//                        guard let samples = samples else {
//                            observer.onNext([])
//                            return
//                        }
//
//                        let rawDatas = samples.compactMap {
//                            $0 as? HKQuantitySample
//                        }
//                        .map { sample in
//                            sample.quantity.doubleValue(for: unit)
//                        }
//
//                        observer.onNext(rawDatas)
//                    }
//            }
//
//            KLHKStore.execute(query)
//
//            return Disposables.create()
//        }
//    }
    
    private static func hasTwoMonthStepData() -> Observable<Bool> {
        return Observable.create { observer in
            let startDate = Date() - 2.months
            let endDate = Date()
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            
            let stepCountQuery = HKSampleQuery(
                sampleType: HKObjectType.quantityType(forIdentifier: .stepCount)!,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, results, _ -> Void in
                DispatchQueue.main.async {
                    guard let results = results else {
                        observer.onNext(false)
                        return
                    }
                    
                    if Device.current.isSimulator {
                        observer.onNext(true)
                    } else {
                        observer.onNext(results.isNotEmpty)
                    }
                }
            }
            
            KLHKStore.execute(stepCountQuery)
            
            return Disposables.create()
        }
    }
}

private func getValueFrom(_ statistic: HKStatistics, unit: HKUnit, filterType: HealthKitFilterType) -> (date: String, value: Double) {
    let date = statistic.startDate.toFormat(Format.Transform.short)
    
    let emptyFeedback = (date, 0.0)
    
    switch filterType {
    case .maxValue:
        let value = statistic.sumQuantity()?.doubleValue(for: unit) ?? 0.0
        
        guard let sources = statistic.sources, sources.count > 1 else {
            // Only one source: return sumQuantity value
            return (date, value)
        }
        
        // Multiple data sources: return the max value
        let maxValue = sources.map { statistic.sumQuantity(for: $0)?.doubleValue(for: unit) }.compactMap { $0 }.max() ?? 0.0
        return (date, maxValue)
        
    case .fitbit:
        log.debug("Fitbit連携 == true, DO NOT NEED STEP FROM HEALTH KIT STEP, RETURN 0.0")
        return emptyFeedback
        
    case .appleWatch:
        guard let appleDeviceSources = filterAppleDeviceSourcesFrom(statistic), appleDeviceSources.isNotEmpty else {
            log.debug("NO SOURCE OF Data: Date: \(date)")
            return emptyFeedback
        }
        
        guard let appleWatchSource = appleDeviceSources.first(where: { $0.name != UIDevice.current.name }) else {
            log.debug("NO appleWatchSource: Date: \(date)")
            return emptyFeedback
        }
        
        let appleWatchStep = statistic.sumQuantity(for: appleWatchSource)?.doubleValue(for: unit) ?? 0.0
        log.debug("Fitbit連携 == false, Apple Watchの歩数のみ同期 == true, JUST GET APPLE WATCH Data: \(appleWatchStep): Date: \(date)")
        return (date, appleWatchStep)
        
    case .iPhone:
        guard let appleDeviceSources = filterAppleDeviceSourcesFrom(statistic), appleDeviceSources.isNotEmpty else {
            log.debug("NO SOURCE OF Data: Date: \(date)")
            return emptyFeedback
        }
        
        guard let iPhoneSource = appleDeviceSources.first(where: { $0.name == UIDevice.current.name }) else {
            log.debug("NO iPhoneSource: Date: \(date)")
            return emptyFeedback
        }
        let iPhoneStep = statistic.sumQuantity(for: iPhoneSource)?.doubleValue(for: unit) ?? 0.0
        log.debug("Fitbit連携 == false, Apple Watchの歩数のみ同期 == false, JUST GET iPhone Data: \(iPhoneStep): Date: \(date)")
        return (date, iPhoneStep)
    }
}

// swiftlint:disable discouraged_optional_collection
private func filterAppleDeviceSourcesFrom(_ statistic: HKStatistics) -> [HKSource]? {
    statistic.sources?.filter { $0.bundleIdentifier.hasPrefix("com.apple.health") }
}
// swiftlint:enable discouraged_optional_collection

private func getMaxValueFrom(_ statistic: HKStatistics, unit: HKUnit) -> (date: String, value: Double) {
    let date = statistic.startDate.toFormat(Format.Transform.short)
    var value = 0.0
    if #available(iOS 12.0, *) {
        value = statistic.mostRecentQuantity()?.doubleValue(for: unit) ?? 0.0
    } else {
        // Fallback on earlier versions
    }
    
    return (date, value)
}
