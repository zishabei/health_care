package jp.co.felicapocketmk.karadalive_flutter_plugin.googlefit.converter

import com.google.android.gms.fitness.data.DataSet
import com.google.android.gms.fitness.result.DataReadResponse
import jp.co.felicapocketmk.karadalive_flutter_plugin.data.DailyActivityData
import jp.co.felicapocketmk.karadalive_flutter_plugin.data.DailyActivityDataMap
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.DateFormatType
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.FitnessActivityCategories
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

/**
 * GoogleFitからデータを取得するI/Fをまとめる
 */
object GoogleFitApiConverter {
    private val sdf = SimpleDateFormat(DateFormatType.YMD_HYPHEN.formatString, Locale.JAPANESE)

    /**
     * 変換処理
     *
     * @param filterCategories [FitnessActivityCategories]
     * @return list of [DailyActivityData]
     */
    fun convertToDailyActivity(dataReadResult: DataReadResponse, filterCategories: List<String>): List<DailyActivityData> {
        if (dataReadResult.buckets.size <= 0) return emptyList()

        val dailyActivityMap = DailyActivityDataMap(arrayListOf())

        dataReadResult.buckets.filter {
            filterCategories.contains(it.activity)
        }.flatMap {
            it.dataSets
        }.forEach { dataSet ->
            dailyActivityMap.updateDailyActivityData(dumpDataSet(dataSet))
        }
        return dailyActivityMap.getDailyActivityDataList()
    }

    /**
     * 変換処理 (フィルターなし)
     *
     * @return list of [DailyActivityData]
     */
    fun convertToDailyActivity(dataReadResult: DataReadResponse): List<DailyActivityData> {
        if (dataReadResult.buckets.size <= 0) return emptyList()

        val dailyActivityMap = DailyActivityDataMap(arrayListOf())

        dataReadResult.buckets.flatMap {
            it.dataSets
        }.forEach { dataSet ->
            dailyActivityMap.updateDailyActivityData(dumpDataSet(dataSet))
        }
        return dailyActivityMap.getDailyActivityDataList()
    }

    /**
     * 変換処理 (フィルターなし、responseがdataSet)
     *
     * @see jp.co.felicapocketmk.karadaliveclient.repository.googlefit.GoogleFitApiService.readFitDataToday
     * @return list of [DailyActivityData]
     */
    fun convertToDailyActivity(dataSet: DataSet): List<DailyActivityData> {
        val dailyActivityMap = DailyActivityDataMap(arrayListOf())
        dailyActivityMap.updateDailyActivityData(dumpDataSet(dataSet))
        return dailyActivityMap.getDailyActivityDataList()
    }

    private fun dumpDataSet(dataSet: DataSet): List<DailyActivityData> {
        val dailyActivityDataList = arrayListOf<DailyActivityData>()

        for (dp in dataSet.dataPoints) {
            val targetDay = sdf.format(dp.getStartTime(TimeUnit.MILLISECONDS))
            var distance = 0L
            var steps = 0L
            var userInputStep = 0L
            var duration = 0L
            var calories = 0.0f

            for (field in dp.dataType.fields) {
                //Logger.i(field.name + " : " + dp.originalDataSource.streamName, dp.getValue(field).toString())
                if (dp.originalDataSource.streamName == "user_input") {
                    when (field.name) {
                        //"distance" -> distance += dp.getValue(field).asFloat().toLong()
                        "steps" -> userInputStep += dp.getValue(field).asInt().toLong()
                        //"duration" -> duration += dp.getValue(field).asInt().toLong()
                        //"calories" -> calories += dp.getValue(field).asFloat()
                    }
                    continue
                }

                when (field.name) {
                    "distance" -> distance += dp.getValue(field).asFloat().toLong()
                    "steps" -> steps += dp.getValue(field).asInt().toLong()
                    "duration" -> duration += dp.getValue(field).asInt().toLong()
                    "calories" -> calories += dp.getValue(field).asFloat()
                }
            }
            val data = DailyActivityData(targetDay, steps, distance).also {
                it.duration = duration
                it.addCalories(calories)
                it.userInputStep = userInputStep
            }
            dailyActivityDataList.add(data)
        }
        return dailyActivityDataList
    }
}
