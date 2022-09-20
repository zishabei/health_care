package jp.co.felicapocketmk.karadalive_flutter_plugin.data

class DailyActivityData {

    interface UpdateStatus {
        companion object {
            // やまぐち仕様
            const val VALUE_TRUE = 1
            const val VALUE_FALSE = 0
            const val VALUE_DEFAULT = VALUE_FALSE
        }
    }

    class ActivityHistoryEntity {
        interface Default {
            companion object {
                const val STEPS = 0L
                const val DISTANCE = 0L
                const val CALORIES = 0L
                const val WEIGHT = 0.0F
                const val STATUS = DailyActivityData.UpdateStatus.VALUE_DEFAULT
                const val STEP_GOAL_ACHIEVED = DailyActivityData.AchievedStatus.NO_ACHIEVED
            }
        }
    }

    interface AchievedStatus {
        companion object {
            // 事実上BooleanだがDBスキーマに合わせてInt
            const val ACHIEVED = 1
            const val NO_ACHIEVED = 0
        }
    }

    // TODO:
    // Entityに変換してDBに入る予定のフィールドはNullable(初期値null)にして
    // レコードupdateの際、更新しない値はnullを指定するような処理にしたいが、
    // 初期値"0"を前提にした既存処理があると困るのでとりあえずはこのままにしておく
    // なお現状、更新しない値はActivityHistoryDao.NO_UPDATE_*を指定する

    // TODO:
    // 数値、日付のフォーマット処理はView側の責務としたい

    var updateStatus: Int = ActivityHistoryEntity.Default.STATUS

    // ----------------------------------------
    // karada.live [data-list]レスポンスがベース
    // ----------------------------------------
    var measuredAt: String // 測定日 DateFormatType.YMD_HYPHEN (yyyy-MM-dd)
    var step: Long = ActivityHistoryEntity.Default.STEPS

    var calories: Long = ActivityHistoryEntity.Default.CALORIES // kcal
    var weight: Float = ActivityHistoryEntity.Default.WEIGHT
    private var floatCalories: Float = ActivityHistoryEntity.Default.CALORIES.toFloat() // float—kcal
    var distance: Long = ActivityHistoryEntity.Default.DISTANCE // meters
    private var floatDistance: Float = ActivityHistoryEntity.Default.DISTANCE.toFloat() // float—meters

    private val activeStep = 0L
    private val bodyFat = 0.0f
    var systolicBp = 0L // 収縮期血圧（上の血圧） [mmHg]
    var diastolicBp = 0L // 拡張期血圧（下の血圧） [mmHg]

    var medicalCheckupLocation = "" // 健診(場所)
    var medicalCheckupContents = "" // 健診(内容)

    var runningTime = 0L // ランニング時間(秒)
    var cyclingTime = 0L // サイクリング時間(秒)
    var duration = 0L // 活動時間(ミリ秒)

    var stepGoalAchieved = AchievedStatus.NO_ACHIEVED  // 歩数目標達成

    var muscle = 0.0f // 筋肉量[kg]
    var muscleRate = 0.0f // 筋肉率[%]
    var bmi = 0.0f // BMI
    var userInputStep: Long = 0L // ユーザー手動入力歩数
    var breakCount = 0 // ブレイク回数

    constructor(measuredAt: String) {
        this.measuredAt = measuredAt
        this.updateStatus = UpdateStatus.VALUE_DEFAULT
    }

    constructor(measuredAt: String, step: Long, distance: Long) {
        this.measuredAt = measuredAt
        this.step = step
        this.distance = distance
        this.updateStatus = UpdateStatus.VALUE_DEFAULT
    }

    constructor(measuredAt: String, step: Long, distance: Long, calories: Long, updateStatus: Int) {
        this.measuredAt = measuredAt
        this.step = step
        this.distance = distance
        this.calories = calories
        this.updateStatus = updateStatus
    }

    constructor(measuredAt: String, step: Long, distance: Long, calories: Long, weight: Float, updateStatus: Int) {
        this.measuredAt = measuredAt
        this.step = step
        this.distance = distance
        this.calories = calories
        this.weight = weight
        this.updateStatus = updateStatus
    }

    constructor(measuredAt: String, step: Long, distance: Long, calories: Long, weight: Float, updateStatus: Int, stepGoalAchieved: Int) {
        this.measuredAt = measuredAt
        this.step = step
        this.distance = distance
        this.calories = calories
        this.weight = weight
        this.updateStatus = updateStatus
        this.stepGoalAchieved = stepGoalAchieved
    }

    override fun toString(): String {
        val s = StringBuilder()
        s.append("++++++++++++++++++++" + "\r\n")
        s.append("日付: $measuredAt\r\n")
        s.append("歩数: $step\r\n")
        s.append("距離: $distance\r\n")
        s.append("距離(Float): $floatDistance\r\n")
        s.append("距離(Float to Long): " + floatDistance.toLong() + "\r\n")
        s.append("カロリー: $calories\r\n")
        s.append("カロリー(Float): $floatCalories\r\n")
        s.append("カロリー(Float to Long): " + floatCalories.toLong() + "\r\n")
        s.append("体重(Float): $weight\r\n")
        // s.append("マイル: " + mile + "\r\n");
        s.append("++++++++++++++++++++")
        return s.toString()
    }

    fun addStep(step: Long) {
        this.step += step
    }

    fun addUserInputStep(userInputStep: Long) {
        this.userInputStep += userInputStep
    }

    fun addDistance(distance: Long) {
        this.distance += distance
    }

    fun addDistance(floatDistance: Float) {
        this.floatDistance += floatDistance
    }

    fun addCalories(floatCalories: Float) {
        this.floatCalories += floatCalories
    }

    // cal
    fun getFloatCalories(): Float {
        return floatCalories
    }

    fun addDuration(duration: Long) {
        this.duration += duration
    }
}
