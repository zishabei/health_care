//
//  MotionManager.swift
//

import Foundation
import CoreMotion
import RxSwift

private let pedometer = CMPedometer()

public enum CoreMotionManager {
    public static func trackingTodayStep() -> Observable<ActivityRecord> {
        return Observable.create { observer in
            self.startUpdate(updateHandler: { motionData in
                observer.onNext(motionData)
            })
            return Disposables.create()
        }
    }
    
    /// For Course: get realtime steps (from course start to now).
    public static func getStepsFrom(_ startDay: Date, to endDate: Date = Date()) -> Observable<ActivityRecord> {
        return Observable.create { observer in
            pedometer.queryPedometerData(from: startDay, to: endDate) { data, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                observer.onNext(ActivityRecord(data: data))
            }
            return Disposables.create()
        }
    }
    
    private static func dealWithData(_ data: CMPedometerData?, updateHandler: @escaping(_ motionData: ActivityRecord) -> Void) {
        if data?.startDate.isToday ?? true {
            updateHandler(ActivityRecord(data: data))
        } else {
            stopUpdate()
            startUpdate(updateHandler: updateHandler)
        }
    }
    
    private static func stopUpdate() {
        pedometer.stopUpdates()
    }
    
    private static func startUpdate(updateHandler: @escaping(_ motionData: ActivityRecord) -> Void) {
        let startOfToday = Date().dateAt(.startOfDay)
        pedometer.startUpdates(from: startOfToday) { data, _ in
            self.dealWithData(data, updateHandler: updateHandler)
        }
    }
}
