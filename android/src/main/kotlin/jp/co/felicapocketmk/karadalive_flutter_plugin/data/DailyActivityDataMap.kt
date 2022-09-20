package jp.co.felicapocketmk.karadalive_flutter_plugin.data

class DailyActivityDataMap(dailyActivityList: List<DailyActivityData>) {

    val count: Int
        get() = dailyActivityDataMap.size

    private val dailyActivityDataMap: MutableMap<String, DailyActivityData> = mutableMapOf()

    init {
        for (dailyActivity in dailyActivityList) {
            dailyActivityDataMap[dailyActivity.measuredAt] = dailyActivity
        }
    }

    // 距離・歩数を加算する
    fun updateDailyActivityData(dailyActivityList: List<DailyActivityData>) {
        for (dailyActivity in dailyActivityList) {
            if (containsKey(dailyActivity.measuredAt)) {
                dailyActivityDataMap[dailyActivity.measuredAt]?.addDistance(dailyActivity.distance)
                dailyActivityDataMap[dailyActivity.measuredAt]?.addStep(dailyActivity.step)
                dailyActivityDataMap[dailyActivity.measuredAt]?.addUserInputStep(dailyActivity.userInputStep)
                dailyActivityDataMap[dailyActivity.measuredAt]?.addDuration(dailyActivity.duration)
                dailyActivityDataMap[dailyActivity.measuredAt]?.addCalories(dailyActivity.getFloatCalories())
            } else {
                dailyActivityDataMap[dailyActivity.measuredAt] = dailyActivity
            }
        }
    }

    fun getDailyActivityData(measuredAt: String): DailyActivityData? {
        return if (dailyActivityDataMap.containsKey(measuredAt)) {
            dailyActivityDataMap[measuredAt]
        } else {
            null
        }
    }

    fun getDailyActivityDataList(): List<DailyActivityData> {
        val dailyActivityDataList = arrayListOf<DailyActivityData>()

        for ((measuredAt, dailyActivityData) in dailyActivityDataMap) {
            dailyActivityDataList.add(dailyActivityData)
        }

        return dailyActivityDataList
    }

    fun addDailyActivityData(dailyActivity: DailyActivityData) {
        if (containsKey(dailyActivity.measuredAt)) {
            return
        }
        dailyActivityDataMap[dailyActivity.measuredAt] = dailyActivity
    }

    fun replaceDailyActivityData(dailyActivity: DailyActivityData) {
        dailyActivityDataMap[dailyActivity.measuredAt] = dailyActivity
    }

    private fun containsKey(measuredAt: String): Boolean {
        return dailyActivityDataMap.containsKey(measuredAt)
    }
}
