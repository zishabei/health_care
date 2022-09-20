//
//  KLActivityService.swift
//

import Foundation
import HealthKit
import RxSwift

public let KLHKStore = HKHealthStore()

public enum KLBackgroundUploadType {
    case step, `break`, weight, bp
}

public struct KLActivityService {
    
    private let disposeBag = DisposeBag()
    
    public func startEnableBackgroundDelivery() {
        log.debug("iOS: CALL: startEnableBackgroundDelivery")
        startEnableBackgroundDeliveryStep()
    }
    
    public func startEnableBackgroundDeliveryWeight() {
        log.debug("iOS: CALL: startEnableBackgroundDeliveryWeight")
        let targetType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let query = HKObserverQuery(sampleType: targetType, predicate: nil) { _, completionHandler, error in
            if let error = error {
                // Perform Proper Error Handling Here...
                log.error("*** An error occured while setting up the stepCount observer. \(error.localizedDescription) ***")
                completionHandler()
                return
            }
        }
        
        KLHKStore.execute(query)
        
        KLHKStore.enableBackgroundDelivery(for: targetType, frequency: .immediate) { _, error in
            if let error = error {
                log.error(error.localizedDescription)
            }
        }
    }
    
    public func startEnableBackgroundDeliveryBp() {
        print("iOS: CALL: startEnableBackgroundDeliveryBp")
        let targetType = HKQuantityType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure)!
        
        let query = HKObserverQuery(sampleType: targetType, predicate: nil) { _, completionHandler, error in
            if let error = error {
                // Perform Proper Error Handling Here...
                log.error("*** An error occured while setting up the stepCount observer. \(error.localizedDescription) ***")
                completionHandler()
                return
            }
        }
        
        KLHKStore.execute(query)
        
        KLHKStore.enableBackgroundDelivery(for: targetType, frequency: .immediate) { _, error in
            if let error = error {
                log.error(error.localizedDescription)
            }
        }
    }
    
    public func disableBackgroundDeliveryWeight() {
        let targetType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        
        KLHKStore.disableBackgroundDelivery(for: targetType) { success, error in
            if let error = error {
                log.error("disableBackgroundDeliveryWeight failed with error: \(error)")
                return
            }
            
            log.debug("disableBackgroundDeliveryWeight result: \(success)")
        }
    }
    
    public func disableBackgroundDeliveryBp() {
        let targetType = HKQuantityType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure)!

        KLHKStore.disableBackgroundDelivery(for: targetType) { success, error in
            if let error = error {
                log.error("disableBackgroundDeliveryBp failed with error: \(error)")
                return
            }
            
            log.debug("disableBackgroundDeliveryBp result: \(success)")
        }
    }
    
    private func startEnableBackgroundDeliveryStep() {
        log.debug("iOS: CALL: startEnableBackgroundDeliveryStep")
        let targetType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let query = HKObserverQuery(sampleType: targetType, predicate: nil) { _, completionHandler, error in
            log.debug("iOS: BackgroundDelivery CALLBACK!")
            if let error = error {
                // Perform Proper Error Handling Here...
                log.error("*** An error occured while setting up the stepCount observer. \(error.localizedDescription) ***")
                completionHandler()
                return
            }
            
            guard UIApplication.shared.applicationState == .background else {
                log.debug("iOS: UIApplication.shared.applicationState: \(UIApplication.shared.applicationState.rawValue). return")
                completionHandler()
                return
            }

            let cache = AppEnvironment.current.cache
            let isHealthKitDeliveried = cache.value(forKey: AppCache.isHealthKitDeliveried) as? Bool

            if isHealthKitDeliveried == true {
                log.warning("iOS: duplicate delivery. do nothing")
                completionHandler()
                return
            }

            cache.set(value: true, forKey: AppCache.isHealthKitDeliveried, neverExpire: false, limit: AppCache.ageHealthKitDelivery)
            
            // Post notification >> AppDelegate >> get 2 days step >> event channel >> Flutter
            NotificationCenter.default.post(name: .healthKitStepsHasChanged, object: nil)
            log.debug("iOS: POST NOTIFICATION: healthKitStepsHasChanged")
        }
        
        KLHKStore.execute(query)
        
        KLHKStore.enableBackgroundDelivery(for: targetType, frequency: .immediate) { _, error in
            if let error = error {
                log.error(error.localizedDescription)
            }
        }
    }
}
