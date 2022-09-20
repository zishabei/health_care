import Flutter
import UIKit
import Foundation
import RxSwift
import HealthKit
import SwiftDate

public class SwiftHealthCarePlugin: NSObject, FlutterPlugin, FlutterCallNativeApi, FlutterCallIosNativeApi {
    public static func register(with registrar: FlutterPluginRegistrar) {
        DateTime.setupRegion()
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api = SwiftHealthCarePlugin.init(messenger)
        FlutterCallNativeApiSetup(messenger, api)
        FlutterCallIosNativeApiSetup(messenger, api);
    }
    
    private let disposeBag = DisposeBag()

    let nativeCallFlutterApi: NativeCallFlutterApi

    init(_ flutterBinaryMessenger: FlutterBinaryMessenger) {
        self.nativeCallFlutterApi = NativeCallFlutterApi(binaryMessenger: flutterBinaryMessenger)
    }

    // background upload 2 day steps
    public func monitorBackgroundStepChanged(completion: @escaping (NativeStep?, FlutterError?) -> Void) {
        print("iOS: CALL monitorBackgroundStepChanged")
        NotificationCenter.default.rx.notification(.healthKitStepsHasChanged)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] in
                log.debug("iOS: GET NOTIFICATION: healthKitStepsHasChanged. CALL getLast2DaysActivity")
                guard let self = self else {
                    return
                }

                HealthKit.getLast2DaysActivity(filterType: .maxValue)
                    .asDriverOnErrorJustComplete()
                    .drive(onNext: { [weak self] activityRecords in
                        guard let self = self else {
                            return
                        }

                        if activityRecords.isEmpty {
                            log.debug("iOS: GET Last2DaysActivity: activityRecords.isEmpty. return")
                            return
                        }

                        var identifier = UIBackgroundTaskIdentifier(rawValue: 0)

                        let application = UIApplication.shared
                        identifier = application.beginBackgroundTask {
                          application.endBackgroundTask(identifier)
                        }

                        log.debug("iOS: GOT Last2DaysActivity. POST TO FLUTTER: \(activityRecords)")

                        let stepRecords = activityRecords.map {
                            NativeStep.make(withDate: $0.day, distance: NSNumber(integerLiteral: Int($0.distance)), steps: NSNumber(integerLiteral: $0.steps))
                        }

                        let result = NativeStepList.make(withRecords: stepRecords)

                        self.nativeCallFlutterApi.uploadBackgroundLast2DaysStepsList(result) { error in
                            if (error != nil) {
                                log.debug("iOS: uploadBackgroundLast2DaysSteps(iOS POST STEP TO FLUTTER), ERROR: \(String(describing: error))")
                            }
                        }

                        self.nativeCallFlutterApi.showLocalNotification { error in
                            if (error != nil) {
                                log.debug("iOS: showLocalNotification. ERROR: \(String(describing: error))")
                            }
                        }
                    })
                    .disposed(by: self.disposeBag)

            })
            .disposed(by: self.disposeBag)
    }

    public func healthAuthorizationRequestMethod(completion: @escaping (FlutterError?) -> Void) {
        print("iOS: CALL healthAuthorizationRequestMethodWithError")
        HKHealthStore.isAuthorized
            .skipWhile { $0 == false }
            .take(1)
            .mapToVoid()
            .withLatestFrom(Observable.just(KLActivityService()))
            .do(onNext: { service in
                service.startEnableBackgroundDelivery()
            }) // startEnableBackgroundDelivery
            .mapToVoid()
            .subscribe(onNext: {
                print("iOS: isAuthorized: TRUE; startEnableBackgroundDelivery: DONE");
                completion(nil)
            })
            .disposed(by: self.disposeBag)
    }

    public func isHealthKitDenied(completion:  @escaping (NSNumber?, FlutterError?) -> Void) {
        log.debug("iOS: CALL: isHealthKitDenied")

        // Use to check if a healthKitDenied alert needs to be showed
        HealthKit.isHealthKitDenied()
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                let result: NSNumber? = NSNumber(booleanLiteral: $0)
                let error: FlutterError? = nil
                completion(result, nil)
            })
            .disposed(by: self.disposeBag)
    }

    public func getTodayStep(completion: @escaping (NativeStep?, FlutterError?) -> Void) {
        log.debug("iOS: CALL getTodayStep")

        HealthKit.getTodayActivity(filterType: .maxValue)
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                log.debug("iOS: coreMotionTodaySteps feedback: \($0.steps)")

                let stepNumber = NSNumber(integerLiteral: $0.steps)
                let distanceNumber = NSNumber(integerLiteral: Int($0.distance))
                let result = NativeStep.make(withDate: $0.day, distance: distanceNumber, steps: stepNumber)
                let error: FlutterError? = nil
                log.debug("iOS: getHistorySteps: \(result)")
                completion(result, error)
            })
            .disposed(by: self.disposeBag)
    }

    public func getHistorySteps(completion: @escaping (NativeStepList?, FlutterError?) -> Void) {
        log.debug("iOS: CALL getHistorySteps")
        HealthKit.getHistoryActivities(filterType: .maxValue)
            .asDriverOnErrorJustComplete()
            .drive(onNext: { activityRecords in
                if activityRecords.isEmpty {
                    log.debug("iOS: CALL getHistorySteps isEmpty. return")
                    return
                }
                let stepRecords = activityRecords.map {
                    NativeStep.make(withDate: $0.day, distance: NSNumber(integerLiteral: Int($0.distance)), steps: NSNumber(integerLiteral: $0.steps))
                }

                let result = NativeStepList.make(withRecords: stepRecords)
                let error: FlutterError? = nil
                log.debug("iOS: getHistorySteps: \(String(describing: result.records))")
                completion(result, error)
            })
            .disposed(by: self.disposeBag)
    }

    public func getLast2DaysSteps(completion: @escaping (NativeStepList?, FlutterError?) -> Void) {
        log.debug("iOS: CALL getLast2DaysSteps")
        HealthKit.getLast2DaysActivity(filterType: .maxValue)
            .asDriverOnErrorJustComplete()
            .drive(onNext: { activityRecords in
                if activityRecords.isEmpty {
                    log.debug("iOS: CALL getLast2DaysSteps isEmpty. return")
                    return
                }
                let stepRecords = activityRecords.map {
                    NativeStep.make(withDate: $0.day, distance: NSNumber(integerLiteral: Int($0.distance)), steps: NSNumber(integerLiteral: $0.steps))
                }

                let result = NativeStepList.make(withRecords: stepRecords)
                let error: FlutterError? = nil
                log.debug("iOS: getHistorySteps: \(result)")
                completion(result, error)
            })
            .disposed(by: self.disposeBag)
    }

    // date format: 'yyyy-MM-dd'
    public func getStepsStartDate(_ startDate: String, endDate: String, completion: @escaping (NativeStepList?, FlutterError?) -> Void) {
        log.debug("iOS: CALL getStepsStartDate:startDate: \(startDate); endDate \(endDate)")

        let start = DateInRegion(startDate)?.date.dateAtStartOf(.day)
        let end = DateInRegion(endDate)?.date.dateAtEndOf(.day)

        log.debug("iOS: CALL getStepsStartDate:startDate: \(start?.description(with: .current)); \(end?.description(with: .current))")

        getStepsStart(start, end: end, completion: completion)
    }
    
    // date format: 'yyyy-MM-dd HH:mm:ss'
    public func getStepsWithPreciseTimeStartDate(_ startDate: String, endDate: String, completion: @escaping (NativeStepList?, FlutterError?) -> Void) {
        log.debug("iOS: CALL getStepsWithPreciseTime:startDate: \(startDate); endDate \(endDate)")

        let start = DateTime.parse(startDate)
        let end = DateTime.parse(endDate)

        log.debug("iOS: CALL getStepsWithPreciseTime:startDate: \(start?.description(with: .current)); \(end?.description(with: .current))")

        getStepsStart(start, end: end, completion: completion)
    }
    
    private func getStepsStart(_ start: Date?, end: Date?, completion: @escaping (NativeStepList?, FlutterError?) -> Void) {
        
        guard let start = start, let end = end else {
            log.debug("iOS: CALL getStepsStartDate start or end is nil . return nil")
            let result = NativeStepList.make(withRecords: nil)
            let error: FlutterError? = nil
            completion(result, error)
            return
        }

        HealthKit.getDailyActivity(startDay: start, endDay: end)
            .asDriverOnErrorJustComplete()
            .drive(onNext: { activityRecords in
                if activityRecords.isEmpty {
                    log.debug("iOS: CALL getStepsStartDate isEmpty. return")
                    let result = NativeStepList.make(withRecords: nil)
                    let error: FlutterError? = nil
                    completion(result, error)
                    return
                }

                let stepRecords = activityRecords.map {
                    NativeStep.make(withDate: $0.day, distance: NSNumber(integerLiteral: Int($0.distance)), steps: NSNumber(integerLiteral: $0.steps))
                }

                let result = NativeStepList.make(withRecords: stepRecords)

                let error: FlutterError? = nil
                log.debug("iOS: getHistorySteps: \(result)")
                completion(result, error)
            })
            .disposed(by: self.disposeBag)
    }
}
