//
//  ActivityRecord+CoreMotion.swift
//

import Foundation
import CoreMotion

extension ActivityRecord {
    public init(data: CMPedometerData?, dateFormat: Format.Transform = .short) {
        let steps = data?.numberOfSteps.intValue ?? 0
        let distance = floor(data?.distance?.doubleValue ?? 0)
        let day = (data?.startDate ?? Date()).toFormat(dateFormat)
        
        self.init(steps: steps, distance: distance, day: day, weight: 0)
    }
}
