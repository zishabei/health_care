import Foundation

public enum AppKeys: String {
    case apiKey = "apiKey"
    case loginId = "loginId"
    case groupCode = "groupCode"
    case nakayoshiCode = "nakayoshiCode"
    case refreshToken = "refreshToken"
    case termId = "termId"
    case kid = "kid"
    case isSignedIn = "isSignedIn"
    case stepGoal = "stepGoal"
    case isJoinRamenGroup = "isJoinRamenGroup"
    case isNeedAddMuscleAndMuscleRate = "isNeedAddMuscleAndMuscleRate"
    case stepRangeLowValue = "stepRangeLowValue"
    case birthday = "birthday"
    case height = "height"
    case nickname = "nickname"
    case gender = "gender"
    case postStamps = "postStamps"
    case checkedPoints = "checkedPoints" // real course
    case migration1to2Finished = "migration1to2Finished"
    case migration24to25Finished = "migration24to25Finished" // for KaradaLive
    case celebratedDate = "celebratedDate"
    case password = "password"
    case area = "area"
    case note1 = "note1"
    case cardSignUpDate = "cardSignUpDate"
    case enterpriseName = "enterpriseName"
    case smoking = "smoking"
    case drinking = "drinking"
    case nakayoshiName = "nakayoshiName"
    case ramenName = "ramenName"
    case waon = "waon"
    case homeSharingServiceNo = "homeSharingServiceNo"
    case firstTimeCompletedCourses = "firstTimeCompletedCourses"
    case alreadyCompletedCourses = "alreadyCompletedCourse"
    case splashDelay = "splashDelay"
//    case challenges = "challenges"
    case lastAccessTime = "lastAccessTime"
    case point = "point"
//    case sharedService = "sharedService"
    case homeCharacterImage = "homeCharacterImage"
    case jid = "jid" // Usef for Tottori
    case eid = "eid" // Use for Fukuoka
    case playSportsCategories = "playSportsCategories"
    case recentlySelectedCategories = "recentlySelectedCategories"
    case systemDetailStr = "systemDetailStr"
    case lastUpdateTargetStepCountDate = "lastUpdateTargetStepCountDate"
    case baseLineStep = "baseLineStep"
    case baseLineBMI = "baseLineBMI"
    case baseLineMuscleRate = "baseLineMuscleRate"
    case accountRegisterDate = "accountRegisterDate" // 初回起動日付 (note1) 福岡
    case lastInvitationUrl = "lastInvitationUrl" // 前回の招待URL 福岡
    case selectedProgramCourseIndex = "selectedProgramCourseIndex" // for chiyoda
    case programAgreementSelected = "programAgreementSelected" // for chiyoda
    case isGPSTurnOn = "isGPSTurnOn" // Saga
    case wheelchairSpeed = "wheelchairSpeed"
    case wheelchairAvgSpeed = "wheelchairAvgSpeed"
    case wheelchairLocationAccuracy = "wheelchairLocationAccuracy"
    case useHealthKitWeight = "useHealthKitWeight"
    case useHealthKitBp = "useHealthKitBp"
    case shopId = "shopId" // 登録店舗ID 3fit
    case shopName = "shopName" // 登録店舗名　3fit
    case lastBedTime = "lastBedTime"
    case weightInput = "weightInput"
    case minBloodpressureInput = "minBloodpressureInput"
    case maxBloodpressureInput = "maxBloodpressureInput"
    case vid = "vid"
    case sapporoMissionId = "sapporoMissionId"
    case sapporoMissionDate = "sapporoMissionDate"
    case migrationYamaguchi52To57Finished = "migrationYamaguchi52To57Finished"
    case isCouseFinishAlertDisplayed = "isCouseFinishAlertDisplayed"
    case weightGoal = "weightGoal"
    case migrationShopNameFinished = "migrationShopNameFinished" // 3fit
    case lastRecordReminderDate = "lastRecordReminderDate" // sapporo
    case lastMissionSelectReminderDate = "lastMissionReminderDate" // sapporo
    case dailyRecordRemindTime = "dailyRecordRemindTime"
    case mealRecordRemindTime = "mealRecordRemindTime"
    case weightRecordRemindTime = "weightRecordRemindTime"
    case examinationRecordRemindTime = "examinationRecordRemindTime"
    case isLocalNotificationEnabled = "isDailyRecordRemindTime" // sapporo gunma
    case fukuokaAppPrefecture = "fukuokaAppPrefecture" // 福岡アプリの県
    case tayoriToken = "tayoriToken"
    case checkInDate = "checkInDate" // 3fit
    case yomsubiAuthToken = "yomsubiAuthToken"
    case isYomsubiCooperationDone = "isYomsubiCooperationDone"
    case isSyncCourseStatusDone = "isSyncCourseStatusDone" // 千代田
    case mealCompleteDate = "mealCompleteDate" // 群馬
    case isAppleWatchOnly = "isAppleWatchOnly" // gunma
    case isFitbitEnabled = "isFitbitEnabled" // gunma
    case stepProgressLowNotificationDate = "stepProgressLowNotificationDate"
    case stepProgressMediumNotificationDate = "stepProgressMediumNotificationDate"
    case stepProgressHighNotificationDate = "stepProgressHighNotificationDate"
    case stepProgressFinishNotificationDate = "stepProgressFinishNotificationDate"
    case celebrateSNSDate = "celebrateSNSDate" // 拡散point獲得日時
    case vwFinishSNSDate = "vwFinishSNSDate" // 拡散point獲得日時
    case isCelebrateSNSPressed = "isCelebrateSNSPressed" // 拡散ボタン押したかどうか、日が変わるとリセット
    case isVWFinishSNSPressed = "isVWFinishSNSPressed" // 拡散ボタン押したかどうか、コースを変えるとリセット
    case introduceDate = "introduceDate" // app紹介date
    case introduceCount = "introduceCount" // app紹介回数
    case ocrTipDate = "ocrTipDate"
    case localSignUpDate = "localSignUpDate" // アカウント登録日時
    case latestMealRecordDate = "latestMealRecordDate"
    case snsShareDate = "snsShareDate"
    case latestWeightRecordDate = "latestWeightRecordDate"
    case previousAppVersion = "previousAppVersion"
    case lastPoints = "lastPoints"
    case isJoinedAreaGroup = "isJoinedAreaGroup"
    case homeImageUrl = "homeImageUrl"
    case insuranceCardInputReminderDisplayedDate = "insuranceCardInputReminderDisplayedDate" // 健康保険証登録催促ダイアログの表示日時
}

public protocol KeyValueStoreType: AnyObject {
    func set(_ value: Bool, forKey defaultName: String)
    func set(_ value: Int, forKey defaultName: String)
    func set(_ value: Any?, forKey defaultName: String)
    func set(_ url: URL?, forKey defaultName: String)
    
    func double(forKey defaultName: String) -> Double
    func bool(forKey defaultName: String) -> Bool
    func dictionary(forKey defaultName: String) -> [String: Any]?
    func array(forKey defaultName: String) -> [Any]?
    func integer(forKey defaultName: String) -> Int
    func object(forKey defaultName: String) -> Any?
    func string(forKey defaultName: String) -> String?
    func url(forKey defaultName: String) -> URL?
    
    func synchronize() -> Bool
    func register(defaults registrationDictionary: [String: Any])
    
    func removeObject(forKey defaultName: String)
    func logout()
    
    var apiKey: String? { get set }
    var loginId: String? { get set }
    var groupCode: String? { get set }
    var isJoinRamenGroup: Bool { get set }
    var isNeedAddMuscleAndMuscleRate: Bool { get set }
    var refreshToken: String? { get set }
    var termId: String? { get set }
    var kid: String? { get set }
    var eid: String? { get set }
    var jid: String? { get set }
    var isSignedIn: Bool { get set }
    var stepGoal: Int { get set }
    var stepRangeLowValue: Int { get set }
    var birthday: Date? { get set }
    var height: Double? { get set }
    var nickname: String? { get set }
    var gender: String? { get set }
    var postStamps: [String] { get set }
    var checkedPoints: [String] { get set }
    var migration1to2Finished: Bool { get set }
    var migration24to25Finished: Bool { get set }
    var password: String? { get set }
    var area: String? { get set }
    var enterpriseName: String? { get set }
    var waon: String? { get set }
    var homeSharingServiceNo: String? { get set }
    var firstTimeCompletedCourses: [String] { get set }
    var alreadyCompletedCourses: [String] { get set }
    var splashDelay: Double { get set }
    var homeCharacterImage: String? { get set }
    var systemDetailStr: String? { get set }
    var baseLineStep: Int { get set }
    var baseLineBMI: Double { get set }
    var baseLineMuscleRate: Double { get set }
    var accountRegisterDate: Date? { get set }
    var lastInvitationUrl: String? { get set }
    var programAgreementSelected: Bool { get set }
    var selectedProgramCourseIndex: Int? { get set }
    var wheelchairSpeed: Double { get set }
    var wheelchairAvgSpeed: Double { get set }
    var wheelchairLocationAccuracy: Int { get set }
    var lastBedTime: Date? { get set }
    var weightInput: Double { get set }
    var minBloodpressureInput: Int { get set }
    var maxBloodpressureInput: Int { get set }
    var vid: String? { get set }
    var sapporoMissionId: Int { get set }
    var sapporoMissionDate: Date? { get set }
    var migrationYamaguchi52To57Finished: Bool { get set }
    var weightGoal: Double? { get set }
    var dailyRecordRemindTime: Date? { get set }
    var mealRecordRemindTime: Date? { get set }
    var weightRecordRemindTime: Date? { get set }
    var examinationRecordRemindTime: Date? { get set }
    var isLocalNotificationEnabled: Bool { get set }
    var fukuokaAppPrefecture: String? { get set }
    var checkInDate: Date? { get set }
    var isYomsubiCooperationDone: Bool { get set }
    var note1: String? { get set }
    var mealCompleteDate: Date? { get set }
    var stepProgressLowNotificationDate: Date? { get set }
    var stepProgressMediumNotificationDate: Date? { get set }
    var stepProgressHighNotificationDate: Date? { get set }
    var stepProgressFinishNotificationDate: Date? { get set }
    var celebrateSNSDate: Date? { get set }
    var vwFinishSNSDate: Date? { get set }
    var isCelebrateSNSPressed: Bool { get set }
    var isVWFinishSNSPressed: Bool { get set }
    var introduceDate: Date? { get set }
    var introduceCount: Int { get set }
    var ocrTipDate: Date? { get set }
    
    var localSignUpDate: Date? { get set }
    var latestMealRecordDate: Date? { get set }
    var snsShareDate: Date? { get set }
    var latestWeightRecordDate: Date? { get set }
    var previousAppVersion: String? { get set }
    var lastPoints: Int { get set }
    var isJoinedAreaGroup: Bool { get set }
    var homeImageUrl: URL? { get set }
    var insuranceCardInputReminderDisplayedDate: Date? { get set }
}

extension KeyValueStoreType {
    public var apiKey: String? {
        get {
            string(forKey: AppKeys.apiKey.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.apiKey.rawValue)
        }
    }
    
    public var loginId: String? {
        get {
            string(forKey: AppKeys.loginId.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.loginId.rawValue)
        }
    }
    
    public var groupCode: String? {
        get {
            string(forKey: AppKeys.groupCode.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.groupCode.rawValue)
        }
    }
    
    public var nakayoshiCode: String? {
        get {
            string(forKey: AppKeys.nakayoshiCode.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.nakayoshiCode.rawValue)
        }
    }
    
    public var refreshToken: String? {
        get {
            string(forKey: AppKeys.refreshToken.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.refreshToken.rawValue)
        }
    }
    
    public var termId: String? {
        get {
            string(forKey: AppKeys.termId.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.termId.rawValue)
        }
    }
    
    public var kid: String? {
        get {
            string(forKey: AppKeys.kid.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.kid.rawValue)
        }
    }
    
    public var vid: String? {
        get {
            string(forKey: AppKeys.vid.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.vid.rawValue)
        }
    }
    
    public var isSignedIn: Bool {
        get {
            bool(forKey: AppKeys.isSignedIn.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isSignedIn.rawValue)
        }
    }
    
    public var isJoinRamenGroup: Bool {
        get {
            bool(forKey: AppKeys.isJoinRamenGroup.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isJoinRamenGroup.rawValue)
        }
    }
    
    public var isNeedAddMuscleAndMuscleRate: Bool {
        get {
            bool(forKey: AppKeys.isNeedAddMuscleAndMuscleRate.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isNeedAddMuscleAndMuscleRate.rawValue)
        }
    }
    
    public var stepGoal: Int {
        get {
            integer(forKey: AppKeys.stepGoal.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.stepGoal.rawValue)
        }
    }
    
    public var stepRangeLowValue: Int {
        get {
            integer(forKey: AppKeys.stepRangeLowValue.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.stepRangeLowValue.rawValue)
        }
    }
    
    public var birthday: Date? {
        get {
            object(forKey: AppKeys.birthday.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.birthday.rawValue)
        }
    }
    
    public var height: Double? {
        get {
            double(forKey: AppKeys.height.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.height.rawValue)
        }
    }
    
    public var nickname: String? {
        get {
            string(forKey: AppKeys.nickname.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.nickname.rawValue)
        }
    }

    public var note1: String? {
        get {
            string(forKey: AppKeys.note1.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.note1.rawValue)
        }
    }
    
    public var gender: String? {
        get {
            string(forKey: AppKeys.gender.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.gender.rawValue)
        }
    }
    
    public var postStamps: [String] {
        get {
            array(forKey: AppKeys.postStamps.rawValue) as? [String] ?? []
        }
        set {
            set(newValue, forKey: AppKeys.postStamps.rawValue)
        }
    }
    
    public var checkedPoints: [String] {
        get {
            array(forKey: AppKeys.checkedPoints.rawValue) as? [String] ?? []
        }
        set {
            set(newValue, forKey: AppKeys.checkedPoints.rawValue)
        }
    }
    
    public var migration1to2Finished: Bool {
        get {
            bool(forKey: AppKeys.migration1to2Finished.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.migration1to2Finished.rawValue)
        }
    }
    
    public var migration24to25Finished: Bool {
        get {
            bool(forKey: AppKeys.migration24to25Finished.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.migration24to25Finished.rawValue)
        }
    }
    
    public var programAgreementSelected: Bool {
        get {
            bool(forKey: AppKeys.programAgreementSelected.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.programAgreementSelected.rawValue)
        }
    }
    
    public var password: String? {
        get {
            string(forKey: AppKeys.password.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.password.rawValue)
        }
    }

    public var area: String? {
        get {
            string(forKey: AppKeys.area.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.area.rawValue)
        }
    }
        
    public var cardSignUpDate: Date? {
        get {
            object(forKey: AppKeys.cardSignUpDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.cardSignUpDate.rawValue)
        }
    }
    
    public var enterpriseName: String? {
        get {
            string(forKey: AppKeys.enterpriseName.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.enterpriseName.rawValue)
        }
    }
    
    public var nakayoshiName: String? {
        get {
            string(forKey: AppKeys.nakayoshiName.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.nakayoshiName.rawValue)
        }
    }
    
    public var ramenName: String? {
        get {
            string(forKey: AppKeys.ramenName.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.ramenName.rawValue)
        }
    }
    
    public var celebratedDate: Date? {
        get {
            object(forKey: AppKeys.celebratedDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.celebratedDate.rawValue)
        }
    }
    
    public var smoking: String? {
        get {
            object(forKey: AppKeys.smoking.rawValue) as? String
        }
        set {
            set(newValue, forKey: AppKeys.smoking.rawValue)
        }
    }

    public var drinking: String? {
        get {
            object(forKey: AppKeys.drinking.rawValue) as? String
        }
        set {
            set(newValue, forKey: AppKeys.drinking.rawValue)
        }
    }
    
    public var waon: String? {
        get {
            string(forKey: AppKeys.waon.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.waon.rawValue)
        }
    }
    
    public var homeSharingServiceNo: String? {
        get {
            string(forKey: AppKeys.homeSharingServiceNo.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.homeSharingServiceNo.rawValue)
        }
    }

    public var firstTimeCompletedCourses: [String] {
        get {
            array(forKey: AppKeys.firstTimeCompletedCourses.rawValue) as? [String] ?? []
        }
        set {
            set(newValue, forKey: AppKeys.firstTimeCompletedCourses.rawValue)
        }
    }
    
    public var alreadyCompletedCourses: [String] {
        get {
            array(forKey: AppKeys.alreadyCompletedCourses.rawValue) as? [String] ?? []
        }
        set {
            set(newValue, forKey: AppKeys.alreadyCompletedCourses.rawValue)
        }
    }
    
    public var splashDelay: Double {
        get {
            let time = double(forKey: AppKeys.splashDelay.rawValue)
            return time == 0 ? 0.5 : time
        }
        set {
            set(newValue, forKey: AppKeys.splashDelay.rawValue)
        }
    }
    
//    public var challenges: [Challenge] {
//        get {
//            let values = array(forKey: AppKeys.challenges.rawValue) as? [[String: Any]]
//            let challenges = values.map { $0.map { Challenge(JSON: $0) }.compactMap { $0 } }
//            return challenges ?? []
//        }
//        set {
//            let uniqueValues = newValue.reduce([], { $0.contains($1) ? $0 : $0 + [$1] })
//            set(uniqueValues.map { $0.toJSON() }, forKey: AppKeys.challenges.rawValue)
//        }
//    }

    public var lastAccessTime: Date? {
        get {
            object(forKey: AppKeys.lastAccessTime.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.lastAccessTime.rawValue)
        }
    }
    
    public var point: Int {
        get {
            integer(forKey: AppKeys.point.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.point.rawValue)
        }
    }
    
//    public var sharedService: SharedService? {
//        get {
//            guard let jsonString = string(forKey: AppKeys.sharedService.rawValue) else {
//                return nil
//            }
//
//            return SharedService(JSONString: jsonString)
//        }
//        set {
//            set(newValue?.toJSONString(), forKey: AppKeys.sharedService.rawValue)
//        }
//    }
    
    public var selectedProgramCourseIndex: Int? {
        get {
            object(forKey: AppKeys.selectedProgramCourseIndex.rawValue) as? Int
        }
        
        set {
            set(newValue, forKey: AppKeys.selectedProgramCourseIndex.rawValue)
        }
    }

    public var homeCharacterImage: String? {
        get {
            string(forKey: AppKeys.homeCharacterImage.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.homeCharacterImage.rawValue)
        }
    }
    
    public var jid: String? {
        get {
            string(forKey: AppKeys.jid.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.jid.rawValue)
        }
    }
    
    public var eid: String? {
        get {
            string(forKey: AppKeys.eid.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.eid.rawValue)
        }
    }
    
    public var playSportsCategories: [String] {
        get {
            array(forKey: AppKeys.playSportsCategories.rawValue) as? [String] ?? []
        }
        set {
            set(newValue, forKey: AppKeys.playSportsCategories.rawValue)
        }
    }
    
    public var recentlySelectedCategories: [String] {
        get {
            array(forKey: AppKeys.recentlySelectedCategories.rawValue) as? [String] ?? []
        }
        set {
            set(newValue, forKey: AppKeys.recentlySelectedCategories.rawValue)
        }
    }

    public var systemDetailStr: String? {
        get {
            string(forKey: AppKeys.systemDetailStr.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.systemDetailStr.rawValue)
        }
    }
    
    public var lastUpdateTargetStepCountDate: Date? {
        get {
            object(forKey: AppKeys.lastUpdateTargetStepCountDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.lastUpdateTargetStepCountDate.rawValue)
        }
    }

    public var baseLineStep: Int {
        get {
            integer(forKey: AppKeys.baseLineStep.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.baseLineStep.rawValue)
        }
    }

    public var baseLineBMI: Double {
        get {
            double(forKey: AppKeys.baseLineBMI.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.baseLineBMI.rawValue)
        }
    }
    
    public var baseLineMuscleRate: Double {
        get {
            double(forKey: AppKeys.baseLineMuscleRate.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.baseLineMuscleRate.rawValue)
        }
    }
    
    public var accountRegisterDate: Date? {
        get {
            object(forKey: AppKeys.accountRegisterDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.accountRegisterDate.rawValue)
        }
    }
    
    public var lastInvitationUrl: String? {
        get {
            string(forKey: AppKeys.lastInvitationUrl.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.lastInvitationUrl.rawValue)
        }
    }
    
    public var isGPSTurnOn: Bool {
        get {
            bool(forKey: AppKeys.isGPSTurnOn.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isGPSTurnOn.rawValue)
        }
    }
    
    public var wheelchairSpeed: Double {
        get {
            let value = double(forKey: AppKeys.wheelchairSpeed.rawValue)
            return value == 0 ? 0.3 : value
        }
        set {
            set(newValue, forKey: AppKeys.wheelchairSpeed.rawValue)
        }
    }
    
    public var wheelchairAvgSpeed: Double {
        get {
            let value = double(forKey: AppKeys.wheelchairAvgSpeed.rawValue)
            return value == 0 ? 0.3 : value
        }
        set {
            set(newValue, forKey: AppKeys.wheelchairAvgSpeed.rawValue)
        }
    }

    public var wheelchairLocationAccuracy: Int {
        get {
            let value = integer(forKey: AppKeys.wheelchairLocationAccuracy.rawValue)
            return value == 0 ? 300 : value
        }
        set {
            set(newValue, forKey: AppKeys.wheelchairLocationAccuracy.rawValue)
        }
    }
    
    public var useHealthKitWeight: Bool {
        get {
            bool(forKey: AppKeys.useHealthKitWeight.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.useHealthKitWeight.rawValue)
        }
    }
    
    public var useHealthKitBp: Bool {
        get {
            bool(forKey: AppKeys.useHealthKitBp.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.useHealthKitBp.rawValue)
        }
    }
    
    public var shopId: Int {
        get {
            integer(forKey: AppKeys.shopId.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.shopId.rawValue)
        }
    }
    
    public var shopName: String? {
        get {
            string(forKey: AppKeys.shopName.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.shopName.rawValue)
        }
    }

    public var lastBedTime: Date? {
        get {
            object(forKey: AppKeys.lastBedTime.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.lastBedTime.rawValue)
        }
    }
    
    public var weightInput: Double {
        get {
            double(forKey: AppKeys.weightInput.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.weightInput.rawValue)
        }
    }
    
    public var minBloodpressureInput: Int {
        get {
            integer(forKey: AppKeys.minBloodpressureInput.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.minBloodpressureInput.rawValue)
        }
    }
    
    public var maxBloodpressureInput: Int {
        get {
            integer(forKey: AppKeys.maxBloodpressureInput.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.maxBloodpressureInput.rawValue)
        }
    }

    public var sapporoMissionId: Int {
        get {
            integer(forKey: AppKeys.sapporoMissionId.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.sapporoMissionId.rawValue)
        }
    }

    public var sapporoMissionDate: Date? {
        get {
            object(forKey: AppKeys.sapporoMissionDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.sapporoMissionDate.rawValue)
        }
    }

    public var migrationYamaguchi52To57Finished: Bool {
        get {
            bool(forKey: AppKeys.migrationYamaguchi52To57Finished.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.migrationYamaguchi52To57Finished.rawValue)
        }
    }

    public var isCouseFinishAlertDisplayed: Bool {
        get {
            bool(forKey: AppKeys.isCouseFinishAlertDisplayed.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isCouseFinishAlertDisplayed.rawValue)
        }
    }
    
    public var weightGoal: Double? {
        get {
            let value = double(forKey: AppKeys.weightGoal.rawValue)
            return value == 0.0 ? nil : value
        }
        set {
            set(newValue, forKey: AppKeys.weightGoal.rawValue)
        }
    }

    public var migrationShopNameFinished: Bool {
        get {
            bool(forKey: AppKeys.migrationShopNameFinished.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.migrationShopNameFinished.rawValue)
        }
    }

    public var lastRecordReminderDate: Date? {
        get {
            object(forKey: AppKeys.lastRecordReminderDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.lastRecordReminderDate.rawValue)
        }
    }

    public var lastMissionSelectReminderDate: Date? {
        get {
            object(forKey: AppKeys.lastMissionSelectReminderDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.lastMissionSelectReminderDate.rawValue)
        }
    }

    public var dailyRecordRemindTime: Date? {
        get {
            object(forKey: AppKeys.dailyRecordRemindTime.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.dailyRecordRemindTime.rawValue)
        }
    }

    public var mealRecordRemindTime: Date? {
        get {
            object(forKey: AppKeys.mealRecordRemindTime.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.mealRecordRemindTime.rawValue)
        }
    }

    public var weightRecordRemindTime: Date? {
        get {
            object(forKey: AppKeys.weightRecordRemindTime.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.weightRecordRemindTime.rawValue)
        }
    }

    public var examinationRecordRemindTime: Date? {
        get {
            object(forKey: AppKeys.examinationRecordRemindTime.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.examinationRecordRemindTime.rawValue)
        }
    }

    public var isLocalNotificationEnabled: Bool {
        get {
            bool(forKey: AppKeys.isLocalNotificationEnabled.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isLocalNotificationEnabled.rawValue)
        }
    }

    public var fukuokaAppPrefecture: String? {
        get {
            string(forKey: AppKeys.fukuokaAppPrefecture.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.fukuokaAppPrefecture.rawValue)
        }
    }

    public var tayoriToken: String? {
        get {
            string(forKey: AppKeys.tayoriToken.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.tayoriToken.rawValue)
        }
    }
    public var checkInDate: Date? {
        get {
            object(forKey: AppKeys.checkInDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.checkInDate.rawValue)
        }
    }

    public var yomsubiAuthToken: String? {
        get {
            string(forKey: AppKeys.yomsubiAuthToken.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.yomsubiAuthToken.rawValue)
        }
    }

    public var isYomsubiCooperationDone: Bool {
        get {
            bool(forKey: AppKeys.isYomsubiCooperationDone.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isYomsubiCooperationDone.rawValue)
        }
    }

    public var isSyncCourseStatusDone: Bool {
        get {
            bool(forKey: AppKeys.isSyncCourseStatusDone.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isSyncCourseStatusDone.rawValue)
        }
    }

    public var mealCompleteDate: Date? {
        get {
            object(forKey: AppKeys.mealCompleteDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.mealCompleteDate.rawValue)
        }
    }

    public var isAppleWatchOnly: Bool {
        get {
            bool(forKey: AppKeys.isAppleWatchOnly.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isAppleWatchOnly.rawValue)
        }
    }

    public var isFitbitEnabled: Bool {
        get {
            bool(forKey: AppKeys.isFitbitEnabled.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isFitbitEnabled.rawValue)
        }
    }

    public var stepProgressLowNotificationDate: Date? {
        get {
            object(forKey: AppKeys.stepProgressLowNotificationDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.stepProgressLowNotificationDate.rawValue)
        }
    }

    public var stepProgressMediumNotificationDate: Date? {
        get {
            object(forKey: AppKeys.stepProgressMediumNotificationDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.stepProgressMediumNotificationDate.rawValue)
        }
    }

    public var stepProgressHighNotificationDate: Date? {
        get {
            object(forKey: AppKeys.stepProgressHighNotificationDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.stepProgressHighNotificationDate.rawValue)
        }
    }

    public var stepProgressFinishNotificationDate: Date? {
        get {
            object(forKey: AppKeys.stepProgressFinishNotificationDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.stepProgressFinishNotificationDate.rawValue)
        }
    }

    public var celebrateSNSDate: Date? {
        get {
            object(forKey: AppKeys.celebrateSNSDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.celebrateSNSDate.rawValue)
        }
    }

    public var vwFinishSNSDate: Date? {
        get {
            object(forKey: AppKeys.vwFinishSNSDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.vwFinishSNSDate.rawValue)
        }
    }

    public var isCelebrateSNSPressed: Bool {
        get {
            bool(forKey: AppKeys.isCelebrateSNSPressed.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isCelebrateSNSPressed.rawValue)
        }
    }

    public var isVWFinishSNSPressed: Bool {
        get {
            bool(forKey: AppKeys.isVWFinishSNSPressed.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isVWFinishSNSPressed.rawValue)
        }
    }

    public var introduceDate: Date? {
        get {
            object(forKey: AppKeys.introduceDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.introduceDate.rawValue)
        }
    }

    public var introduceCount: Int {
        get {
            integer(forKey: AppKeys.introduceCount.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.introduceCount.rawValue)
        }
    }

    public var ocrTipDate: Date? {
        get {
            object(forKey: AppKeys.ocrTipDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.ocrTipDate.rawValue)
        }
    }

    public var localSignUpDate: Date? {
        get {
            object(forKey: AppKeys.localSignUpDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.localSignUpDate.rawValue)
        }
    }

    public var latestMealRecordDate: Date? {
        get {
            object(forKey: AppKeys.latestMealRecordDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.latestMealRecordDate.rawValue)
        }
    }

    public var snsShareDate: Date? {
        get {
            object(forKey: AppKeys.snsShareDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.snsShareDate.rawValue)
        }
    }

    public var latestWeightRecordDate: Date? {
        get {
            object(forKey: AppKeys.latestWeightRecordDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.latestWeightRecordDate.rawValue)
        }
    }
    
    public var previousAppVersion: String? {
        get {
            string(forKey: AppKeys.previousAppVersion.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.previousAppVersion.rawValue)
        }
    }
    
    public var lastPoints: Int {
        get {
            integer(forKey: AppKeys.lastPoints.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.lastPoints.rawValue)
        }
    }
    
    public var isJoinedAreaGroup: Bool {
        get {
            bool(forKey: AppKeys.isJoinedAreaGroup.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.isJoinedAreaGroup.rawValue)
        }
    }

    public var homeImageUrl: URL? {
        get {
            url(forKey: AppKeys.homeImageUrl.rawValue)
        }
        set {
            set(newValue, forKey: AppKeys.homeImageUrl.rawValue)
        }
    }
    
    public var insuranceCardInputReminderDisplayedDate: Date? {
        get {
            object(forKey: AppKeys.insuranceCardInputReminderDisplayedDate.rawValue) as? Date
        }
        set {
            set(newValue, forKey: AppKeys.insuranceCardInputReminderDisplayedDate.rawValue)
        }
    }
    
    public func logout() {
        loginId = nil
        groupCode = nil
        apiKey = nil
        refreshToken = nil
        isSignedIn = false
        password = nil
        termId = nil
        kid = nil
        jid = nil
        eid = nil
        stepGoal = 0
        birthday = nil
        height = 0
        nickname = nil
        gender = nil
        note1 = nil
        postStamps.removeAll()
        checkedPoints.removeAll()
        password = nil
        area = nil
        enterpriseName = nil
        smoking = nil
        drinking = nil
        nakayoshiCode = nil
        nakayoshiName = nil
        ramenName = nil
        waon = nil
        homeSharingServiceNo = nil
        cardSignUpDate = nil
        firstTimeCompletedCourses.removeAll()
        alreadyCompletedCourses.removeAll()
//        challenges.removeAll()
        lastAccessTime = nil
        point = 0
//        sharedService = nil
        systemDetailStr = nil
        baseLineStep = 0
        baseLineBMI = 0
        baseLineMuscleRate = 0
        lastUpdateTargetStepCountDate = nil
        accountRegisterDate = nil
        lastInvitationUrl = nil
        isGPSTurnOn = false
        homeCharacterImage = nil
        selectedProgramCourseIndex = nil
        programAgreementSelected = false
        wheelchairSpeed = 0
        wheelchairAvgSpeed = 0
        wheelchairLocationAccuracy = 0
        useHealthKitWeight = false
        useHealthKitBp = false
        shopId = 0
        shopName = nil
        lastBedTime = nil
        stepRangeLowValue = 0
        weightInput = 0
        minBloodpressureInput = 0
        maxBloodpressureInput = 0
        sapporoMissionId = 0
        sapporoMissionDate = nil
        migrationYamaguchi52To57Finished = false
        isCouseFinishAlertDisplayed = false
        lastRecordReminderDate = nil
        lastMissionSelectReminderDate = nil
        weightGoal = nil
        dailyRecordRemindTime = nil
        mealRecordRemindTime = nil
        weightRecordRemindTime = nil
        examinationRecordRemindTime = nil
        isLocalNotificationEnabled = true
        fukuokaAppPrefecture = nil
        tayoriToken = nil
        checkInDate = nil
        yomsubiAuthToken = nil
        isYomsubiCooperationDone = false
        isSyncCourseStatusDone = false
        mealCompleteDate = nil
        isAppleWatchOnly = false
        isFitbitEnabled = false
        stepProgressLowNotificationDate = nil
        stepProgressMediumNotificationDate = nil
        stepProgressHighNotificationDate = nil
        stepProgressFinishNotificationDate = nil
        celebrateSNSDate = nil
        vwFinishSNSDate = nil
        isCelebrateSNSPressed = false
        isVWFinishSNSPressed = false
        introduceDate = nil
        introduceCount = 0
        ocrTipDate = nil
        localSignUpDate = nil
        latestMealRecordDate = nil
        snsShareDate = nil
        latestWeightRecordDate = nil
        previousAppVersion = nil
        lastPoints = -1
        homeImageUrl = nil
        insuranceCardInputReminderDisplayedDate = nil
    }
}

extension UserDefaults: KeyValueStoreType {}

public class MockKeyValueStore: KeyValueStoreType {
    public var store: [String: Any] = [:]
    
    public func set(_ value: Bool, forKey defaultName: String) {
        self.store[defaultName] = value
    }
    
    public func set(_ value: Int, forKey defaultName: String) {
        self.store[defaultName] = value
    }
    
    public func set(_ value: Any?, forKey key: String) {
        self.store[key] = value
    }
    
    public func set(_ value: URL?, forKey key: String) {
        self.store[key] = value
    }
    
    public func bool(forKey defaultName: String) -> Bool {
        self.store[defaultName] as? Bool ?? false
    }
    
    public func dictionary(forKey key: String) -> [String: Any]? {
        self.object(forKey: key) as? [String: Any]
    }
    
    public func array(forKey defaultName: String) -> [Any]? {
        self.object(forKey: defaultName) as? [Any]
    }

    public func integer(forKey defaultName: String) -> Int {
        self.store[defaultName] as? Int ?? 0
    }
    
    public func integerForNil(forKey defaultName: String) -> Int? {
        self.store[defaultName] as? Int
    }
    
    public func object(forKey key: String) -> Any? {
        self.store[key]
    }
    
    public func string(forKey defaultName: String) -> String? {
        self.store[defaultName] as? String
    }
    
    public func double(forKey defaultName: String) -> Double {
        self.store[defaultName] as? Double ?? 0
    }
    
    public func url(forKey defaultName: String) -> URL? {
        store[defaultName] as? URL
    }
    
    public func removeObject(forKey defaultName: String) {
        self.set(nil, forKey: defaultName)
    }
    
    public func synchronize() -> Bool {
        true
    }
    
    public func register(defaults registrationDictionary: [String: Any]) {
        self.register(defaults: [:])
    }
    
    public init() {
    }
}
