//
//  NotificationNames.swift
//

import Foundation

extension NSNotification.Name {
    public static let invalidPassword = NSNotification.Name("invalidPassword")
    public static let verificationPhoneNumber = NSNotification.Name("verificationPhoneNumber")
    public static let ipRestricted = NSNotification.Name("ipRestricted")
    public static let shouldCloseMenu = NSNotification.Name("shouldCloseMenu")
    public static let logout = NSNotification.Name("logout")
    public static let uploadHistoryActivitySuccess = NSNotification.Name("uploadHistoryActivitySuccess")
    public static let uploadTodayActivitySuccess = NSNotification.Name("uploadTodayActivitySuccess")
    public static let uploadBundleBreakSuccess = NSNotification.Name("uploadBundleBreakSuccess")
    public static let backToHomeFromEventPoint = NSNotification.Name("backToHomeFromEventPoint")
    public static let HomeRefreshControlPulled = NSNotification.Name("HomeRefreshControlPulled")
    public static let networkError = NSNotification.Name("networkError")
    public static let didStepChanged = NSNotification.Name("didStepChanged") // for virtual walking

    // Ibaraki
    public static let timingAlert = NSNotification.Name("timingAlert")
    public static let rootReload = NSNotification.Name("rootReload")
    public static let autoStopTiming = NSNotification.Name("autoStopTiming")
    
    // MallWalking
    public static let walkingStatusAddReachedBeacon = NSNotification.Name("walkingStatusAddReachedBeacon")
    public static let sharedServiceChanged = NSNotification.Name("sharedServiceChanged")
    
    public static let stepGoalChanged = NSNotification.Name("stepGoalChanged")
    
    public static let signedIn = NSNotification.Name("signedIn")
    public static let tutorialFinished = NSNotification.Name("tutorialFinished")
    public static let tutorialFinishedKobayashi = NSNotification.Name("tutorialFinishedKobayashi")

    public static let wheelchairStepUploaded = NSNotification.Name("wheelchairStepUploaded")
    
    // 3fit
    public static let signupStepOneFinished = NSNotification.Name("signupStepOneFinished")

    public static let weightInputed = NSNotification.Name("weightInputed")
    public static let bpInputed = NSNotification.Name("bpInputed")

    public static let groupCodeInputFinished = NSNotification.Name("groupCodeInputFinished") // sapporo
    public static let mealImageUpdated = NSNotification.Name("mealImageUpdated") // sapporo
    public static let loginTopLoginBtnTapped = NSNotification.Name("loginTopLoginBtnTapped") // kobayashi
    public static let loginTopDebugSignupBtnTapped = NSNotification.Name("loginTopDebugSignupBtnTapped") // kobayashi
    public static let missionSelectAlertFinished = NSNotification.Name("missionSelectAlertFinished") // sapporo
    public static let firstLoginSuccess = NSNotification.Name("firstLoginSuccess") // kobayashi
    public static let debugStepGoal = NSNotification.Name("debugStepGoal") // sapporo
    public static let sapporoRankConfirmed = NSNotification.Name("sapporoRankConfirmed")
    public static let didOpenedAppWithConnectResult = NSNotification.Name("didOpenedAppWithConnectResult")
    public static let needShowAccount = NSNotification.Name("needShowAccount")
    
    public static let healthKitStepsHasChanged = NSNotification.Name("healthKitStepsHasChanged")
}
