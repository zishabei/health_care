package jp.co.felicapocketmk.karadalive_flutter_plugin.googlefit

import android.content.Context
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.data.DataSet
import com.google.android.gms.fitness.data.DataSource
import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.data.Field
import com.google.android.gms.fitness.request.DataReadRequest
import com.google.android.gms.fitness.result.DataReadResponse
import jp.co.felicapocketmk.karadalive_flutter_plugin.data.BreakResult
import jp.co.felicapocketmk.karadalive_flutter_plugin.data.BreakType
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.DateFormatType
import jp.co.felicapocketmk.karadalive_flutter_plugin.util.Logger
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

/**
 * GoogleFitから歩数を取得しブレイク回数をカウントする
 */
object GoogleFitBreakManager {

    interface GoogleFitBreakManagerListener : EventListener {
        fun onReadDataComplete(breakResults: Map<String, BreakResult>?)
    }

    private var listener: GoogleFitBreakManagerListener? = null


    //    private val sdf_daytime: SimpleDateFormat by lazy {
//        SimpleDateFormat(DateFormatType.YMD_HMS_HYPHEN.formatString, Locale.JAPANESE)
//    }
    private val sdf_day: SimpleDateFormat by lazy {
        SimpleDateFormat(DateFormatType.YMD_HYPHEN.formatString, Locale.JAPANESE)
    }

    fun setListener(listener: GoogleFitBreakManagerListener) {
        GoogleFitBreakManager.listener = listener
    }

    /**
     * 期間を指定してFitからデータを取得する
     */
    fun readFitData(context: Context, startDate: Date, endDate: Date) {

        val account =
            GoogleSignIn.getLastSignedInAccount(context) ?: throw Throwable("Can not get LastSignedInAccount.")
        val readRequest = queryFitnessData(startDate, endDate)

        try {

            // ブレイク回数カウント用の一時データ
            // キー: 日付(yyyy-MM-dd)
            // 内容: 各日のブレイク判定
            val daysActivity = mutableMapOf<String, Array<Array<Boolean>>>()

            val cal = Calendar.getInstance().apply {
                time = startDate
            }
            while (cal.timeInMillis <= endDate.time) {
                // 日毎のブレイク状態判定用の配列を生成
                // size: 24 (0〜23時)
                // 内容: 真偽配列 (size:4 初期値: false) ※1時間に80歩以上, 1時間に400歩以上, 毎時0:00〜29:59に240歩以上, 毎時30:00～59:59に240歩以上 を達成した場合に true とする
                daysActivity[sdf_day.format(cal.time)] = Array(24) { Array(4) { false } }
                cal.add(Calendar.DAY_OF_MONTH, 1)
            }

            Fitness.getHistoryClient(context, account).readData(readRequest).addOnSuccessListener { dataReadResponse ->

                val convertedResult = convertToDailyActivity(dataReadResponse, daysActivity)
//                convertedResult.forEach {
//                    Logger.i(this.javaClass.name, "-- ${it.key} --")
//                    for (i in 0 until it.value.size) {
//                        Logger.i(this.javaClass.name, i.toString() + "時 " + Arrays.toString(it.value[i]))
//                    }
//                }

                // 結果データを生成
                val breakResult = mutableMapOf<String, BreakResult>()
                convertedResult.forEach { result ->

                    val timeResult: Array<BreakType> = Array(24) { BreakType.NONE }
                    val summary: Array<Int> = Array(3) { 0 }

                    result.value.forEachIndexed { index, booleans ->
                        if (booleans[0]) {
                            timeResult[index] = BreakType.COUNT1_1MINUTE_1HOUR
                        }
                        if (booleans[1]) {
                            timeResult[index] = BreakType.COUNT1_5MINUTE_1HOUR
                        }
                        if (booleans[2] && booleans[3]) {
                            timeResult[index] = BreakType.COUNT2_3MINUTE_30MINUTE
                        }
                    }

                    summary[BreakType.COUNT1_1MINUTE_1HOUR.position] =
                        timeResult.filter { it == BreakType.COUNT1_1MINUTE_1HOUR }.size
                    summary[BreakType.COUNT1_5MINUTE_1HOUR.position] =
                        timeResult.filter { it == BreakType.COUNT1_5MINUTE_1HOUR }.size
                    summary[BreakType.COUNT2_3MINUTE_30MINUTE.position] =
                        timeResult.filter { it == BreakType.COUNT2_3MINUTE_30MINUTE }.size

                    breakResult[result.key] =
                        BreakResult(timeResult, summary)
                }

                // ** デバッグ **
                Logger.i(this.javaClass.name, "-----------------")
                Logger.i(this.javaClass.name, "breakResult: $breakResult")
                for (item in breakResult) {
                    Logger.i(this.javaClass.name, "-----------------")
                    Logger.i(this.javaClass.name, "日付: ${item.key}")
                    Logger.i(this.javaClass.name, "-- 時間毎のブレイク判定 (timeResult) --")
                    for (i in 0 until item.value.timeResult.size) {
                        // 時間毎のブレイク判定
                        Logger.i(
                            this.javaClass.name,
                            "${i}時: ${item.value.timeResult[i]} -> " + when (item.value.timeResult[i]) {
                                BreakType.NONE -> "ブレイクなし"
                                BreakType.COUNT1_1MINUTE_1HOUR -> "1時間に1分間"
                                BreakType.COUNT1_5MINUTE_1HOUR -> "1時間に5分間"
                                BreakType.COUNT2_3MINUTE_30MINUTE -> "30分間に3分間を2回"
                            }
                        )
                    }
                    Logger.i(this.javaClass.name, "-- 1日あたりのブレイク回数 (summary) --")
                    Logger.i(
                        this.javaClass.name,
                        "1時間に1分間: " + item.value.summary[BreakType.COUNT1_1MINUTE_1HOUR.position] + "回"
                    )
                    Logger.i(
                        this.javaClass.name,
                        "1時間に5分間: " + item.value.summary[BreakType.COUNT1_5MINUTE_1HOUR.position] + "回"
                    )
                    Logger.i(
                        this.javaClass.name,
                        "30分間に3分間を2回: " + item.value.summary[BreakType.COUNT2_3MINUTE_30MINUTE.position] + "回"
                    )
                    Logger.i(this.javaClass.name, "-----------------")
                }
                // ** デバッグ **

                listener?.onReadDataComplete(breakResult)

            }.addOnFailureListener { listener?.onReadDataComplete(null) }

        } catch (t: Throwable) {
            when (t) {
                is ParseException -> {
                    Logger.e(this.javaClass.name, "BreakManager readFitData ParseException: " + t.message)
                    listener?.onReadDataComplete(null)
                }
                else -> {
                    Logger.e(this.javaClass.name, "BreakManager readFitData  Exception: " + t.message)
                    listener?.onReadDataComplete(null)
                }
            }
        }
    }

    // リクエストクエリ(期間を指定)
    @Throws(ParseException::class)
    private fun queryFitnessData(startDate: Date, endDate: Date): DataReadRequest {

        val cal = Calendar.getInstance()

        cal.time = startDate
        cal.set(Calendar.HOUR_OF_DAY, 0)
        cal.set(Calendar.MINUTE, 0)
        cal.set(Calendar.SECOND, 0)
        cal.set(Calendar.MILLISECOND, 0)
        cal.add(Calendar.DAY_OF_MONTH, 0)
        val startTime = cal.timeInMillis

        cal.time = endDate
        cal.set(Calendar.HOUR_OF_DAY, 23)
        cal.set(Calendar.MINUTE, 59)
        cal.set(Calendar.SECOND, 59)
        cal.set(Calendar.MILLISECOND, 999)
        cal.add(Calendar.DAY_OF_MONTH, 0)
        val endTime = cal.timeInMillis

//        Logger.i(this.javaClass.name, "Range Start: " + sdf.format(startTime))
//        Logger.i(this.javaClass.name, "Range End: " + sdf.format(endTime))

        val estimatedStepDeltas = DataSource.Builder()
            .setDataType(DataType.TYPE_STEP_COUNT_DELTA)
            .setType(DataSource.TYPE_DERIVED)
            .setStreamName("estimated_steps")
            .setAppPackageName("com.google.android.gms")
            .build()

        return DataReadRequest.Builder()
            .bucketByTime(1, TimeUnit.HOURS)
            .aggregate(estimatedStepDeltas, DataType.TYPE_STEP_COUNT_DELTA)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()
    }

    private fun convertToDailyActivity(
        dataReadResult: DataReadResponse,
        walkingResult: Map<String, Array<Array<Boolean>>>
    ): Map<String, Array<Array<Boolean>>> {

        if (dataReadResult.buckets.size > 0) {

            for (bucket in dataReadResult.buckets) {

                // Logger.d(this.javaClass.name, "↓↓↓↓↓" + bucket.activity + "↓↓↓↓↓")

                val dataSets = bucket.dataSets
                for (dataSet in dataSets) {
                    dumpDataSet(dataSet, walkingResult)
                }

                // Logger.d(this.javaClass.name, "↑↑↑↑↑" + bucket.activity + "↑↑↑↑↑")
            }

        } else if (dataReadResult.dataSets.size > 0) {

            for (dataSet in dataReadResult.dataSets) {
                dumpDataSet(dataSet, walkingResult)
            }
        }

        return walkingResult
    }

    private fun dumpDataSet(dataSet: DataSet, walkingResult: Map<String, Array<Array<Boolean>>>) {

        for (dp in dataSet.dataPoints) {

//            val walkingStartTime = sdf_daytime.format(dp.getStartTime(TimeUnit.MILLISECONDS))
//            val walkingEndTime = sdf_daytime.format(dp.getEndTime(TimeUnit.MILLISECONDS))

            for (field in dp.dataType.fields) {

                if (field.name == Field.FIELD_STEPS.name) {

                    val steps = dp.getValue(field).asInt().toLong()
//                    Logger.d(this.javaClass.name, "walkingTime: $walkingStartTime - $walkingEndTime steps: $steps")

                    var i = 0L
                    while (dp.getStartTime(TimeUnit.MILLISECONDS) + i < dp.getEndTime(TimeUnit.MILLISECONDS)) {

                        val startTime = dp.getStartTime(TimeUnit.MILLISECONDS) + i

                        val cal = Calendar.getInstance()
                        cal.timeInMillis = startTime
                        val hour = cal.get(Calendar.HOUR_OF_DAY)

                        val walkingDay = sdf_day.format(startTime)

                        if (walkingResult.containsKey(walkingDay)) {

                            if (steps >= BreakType.COUNT1_1MINUTE_1HOUR.leastStep) {
                                walkingResult[walkingDay]?.get(hour)?.set(0, true)
                            }
                            if (steps >= BreakType.COUNT1_5MINUTE_1HOUR.leastStep) {
                                walkingResult[walkingDay]?.get(hour)?.set(1, true)
                            }
                            if (steps >= BreakType.COUNT2_3MINUTE_30MINUTE.leastStep) {

                                val startMinute = Integer.parseInt(
                                    SimpleDateFormat(
                                        "m",
                                        Locale.JAPANESE
                                    ).format(startTime)
                                )
                                val endMinute = Integer.parseInt(
                                    SimpleDateFormat(
                                        "m",
                                        Locale.JAPANESE
                                    ).format(dp.getEndTime(TimeUnit.MILLISECONDS))
                                )

                                if (startMinute in 0..29) {
                                    walkingResult[walkingDay]?.get(hour)?.set(2, true)
                                }
                                if (startMinute in 30..59) {
                                    walkingResult[walkingDay]?.get(hour)?.set(3, true)
                                }

                                if (endMinute in 0..29) {
                                    walkingResult[walkingDay]?.get(hour)?.set(2, true)
                                }
                                if (endMinute in 30..59) {
                                    walkingResult[walkingDay]?.get(hour)?.set(3, true)
                                }

                            }
                        }

                        i += 1800000 // 30分加算
                    }

                }
            }
        }
    }

}